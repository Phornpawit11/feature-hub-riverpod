import { InjectModel } from '@nestjs/mongoose';
import {
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { randomUUID } from 'crypto';
import { OAuth2Client } from 'google-auth-library';
import {
  AuthSuccessResponse,
  AuthUserResponse,
  JwtPayload,
  RefreshJwtPayload,
  LogoutResponse,
} from './auth-user.types';
import { User, UserDocument } from './user.schema';
import { LoginDto } from './dto/login.dto';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { LogoutDto } from './dto/logout.dto';
import { resolveAuthConfig } from '../../config/auth.config';

@Injectable()
export class AuthService {
  private readonly googleClient = new OAuth2Client();
  private readonly authConfig: ReturnType<typeof resolveAuthConfig>;

  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {
    this.authConfig = resolveAuthConfig(configService);
  }

  async login(loginDto: LoginDto): Promise<AuthSuccessResponse> {
    const email = loginDto.email.trim().toLowerCase();
    const user = await this.userModel.findOne({ email }).exec();

    if (!user?.passwordHash) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    return this.createAuthResponse(user);
  }

  async loginWithGoogle(
    googleLoginDto: GoogleLoginDto,
  ): Promise<AuthSuccessResponse> {
    const clientId = this.configService.get<string>('GOOGLE_CLIENT_ID');
    let payload;

    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken: googleLoginDto.idToken,
        audience: clientId || undefined,
      });
      payload = ticket.getPayload();
    } catch {
      throw new UnauthorizedException('Invalid Google token');
    }

    if (!payload?.sub || !payload.email) {
      throw new UnauthorizedException('Invalid Google token');
    }

    const email = payload.email.trim().toLowerCase();
    const fallbackDisplayName = email.split('@')[0];

    let user =
      (await this.userModel.findOne({ googleSub: payload.sub }).exec()) ??
      (await this.userModel.findOne({ email }).exec());

    if (!user) {
      user = await this.userModel.create({
        email,
        displayName: payload.name?.trim() || fallbackDisplayName,
        avatarUrl: payload.picture,
        provider: 'google',
        googleSub: payload.sub,
      });
    } else {
      user.email = email;
      user.displayName =
        payload.name?.trim() || user.displayName || fallbackDisplayName;
      user.avatarUrl = payload.picture ?? user.avatarUrl;
      user.googleSub = payload.sub;
      user.provider = 'google';
      await user.save();
    }

    return this.createAuthResponse(user);
  }

  async refresh(
    refreshTokenDto: RefreshTokenDto,
  ): Promise<AuthSuccessResponse> {
    const payload = await this.verifyRefreshToken(refreshTokenDto.refreshToken);
    const user = await this.userModel.findById(payload.sub).exec();

    if (
      !user?.refreshTokenHash ||
      !user.refreshTokenExpiresAt ||
      !user.refreshSessionId
    ) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    if (user.refreshSessionId != payload.sid) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    if (user.refreshTokenExpiresAt.getTime() <= Date.now()) {
      await this.clearRefreshSession(user);
      throw new UnauthorizedException('Invalid refresh token');
    }

    const isRefreshTokenValid = await bcrypt.compare(
      refreshTokenDto.refreshToken,
      user.refreshTokenHash,
    );

    if (!isRefreshTokenValid) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const nextSession = await this.createTokenPair(user);
    const updateResult = await this.userModel.updateOne(
      {
        _id: user.id,
        refreshSessionId: user.refreshSessionId,
        refreshTokenHash: user.refreshTokenHash,
      },
      {
        $set: {
          refreshSessionId: nextSession.refreshSessionId,
          refreshTokenHash: nextSession.refreshTokenHash,
          refreshTokenExpiresAt: nextSession.refreshTokenExpiresAt,
        },
      },
    );

    if (updateResult.modifiedCount !== 1) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    return {
      accessToken: nextSession.accessToken,
      refreshToken: nextSession.refreshToken,
      user: this.toAuthUser(user),
    };
  }

  async logout(logoutDto: LogoutDto): Promise<LogoutResponse> {
    const payload = await this.verifyRefreshToken(logoutDto.refreshToken);
    const user = await this.userModel.findById(payload.sub).exec();

    if (
      !user?.refreshTokenHash ||
      !user.refreshTokenExpiresAt ||
      !user.refreshSessionId
    ) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    if (user.refreshSessionId != payload.sid) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    if (user.refreshTokenExpiresAt.getTime() <= Date.now()) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const isRefreshTokenValid = await bcrypt.compare(
      logoutDto.refreshToken,
      user.refreshTokenHash,
    );

    if (!isRefreshTokenValid) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const updateResult = await this.userModel.updateOne(
      {
        _id: user.id,
        refreshSessionId: user.refreshSessionId,
        refreshTokenHash: user.refreshTokenHash,
      },
      {
        $unset: {
          refreshSessionId: 1,
          refreshTokenHash: 1,
          refreshTokenExpiresAt: 1,
        },
      },
    );

    if (updateResult.modifiedCount !== 1) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    return { success: true };
  }

  toAuthUser(user: UserDocument): AuthUserResponse {
    return {
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl ?? null,
      provider: user.provider,
    };
  }

  private async createAuthResponse(
    user: UserDocument,
  ): Promise<AuthSuccessResponse> {
    const session = await this.createTokenPair(user);

    user.refreshSessionId = session.refreshSessionId;
    user.refreshTokenHash = session.refreshTokenHash;
    user.refreshTokenExpiresAt = session.refreshTokenExpiresAt;
    await user.save();

    return {
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      user: this.toAuthUser(user),
    };
  }

  private async verifyRefreshToken(
    refreshToken: string,
  ): Promise<RefreshJwtPayload> {
    try {
      return await this.jwtService.verifyAsync<RefreshJwtPayload>(
        refreshToken,
        {
          secret: this.authConfig.refreshSecret,
        },
      );
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  private resolveTokenExpiry(payload: RefreshJwtPayload): Date {
    if (!payload.exp) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    return new Date(payload.exp * 1000);
  }

  private async createTokenPair(user: UserDocument): Promise<{
    accessToken: string;
    refreshToken: string;
    refreshSessionId: string;
    refreshTokenHash: string;
    refreshTokenExpiresAt: Date;
  }> {
    const accessPayload: JwtPayload = {
      sub: user.id,
      email: user.email,
    };
    const refreshSessionId = randomUUID();
    const refreshPayload = {
      ...accessPayload,
      sid: refreshSessionId,
    };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(accessPayload),
      this.jwtService.signAsync(refreshPayload, {
        secret: this.authConfig.refreshSecret,
        expiresIn: this.authConfig.refreshExpiresIn,
      }),
    ]);

    const verifiedRefreshPayload =
      await this.jwtService.verifyAsync<RefreshJwtPayload>(refreshToken, {
        secret: this.authConfig.refreshSecret,
      });

    return {
      accessToken,
      refreshToken,
      refreshSessionId,
      refreshTokenHash: await bcrypt.hash(refreshToken, 10),
      refreshTokenExpiresAt: this.resolveTokenExpiry(verifiedRefreshPayload),
    };
  }

  private async clearRefreshSession(user: UserDocument): Promise<void> {
    user.refreshSessionId = undefined;
    user.refreshTokenHash = undefined;
    user.refreshTokenExpiresAt = undefined;
    await user.save();
  }
}

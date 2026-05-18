import { InjectModel } from '@nestjs/mongoose';
import {
  BadRequestException,
  ConflictException,
  HttpException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { randomInt, randomUUID } from 'crypto';
import { OAuth2Client, TokenPayload } from 'google-auth-library';
import {
  CheckEmailAvailabilityResponse,
  AuthSuccessResponse,
  AuthUserResponse,
  JwtPayload,
  RefreshJwtPayload,
  LogoutResponse,
  RegisterPendingResponse,
} from './auth-user.types';
import { User, UserDocument } from './user.schema';
import { CheckEmailDto } from './dto/check-email.dto';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { LogoutDto } from './dto/logout.dto';
import { resolveAuthConfig } from '../../config/auth.config';
import { VerifyEmailOtpDto } from './dto/verify-email-otp.dto';
import { ResendEmailOtpDto } from './dto/resend-email-otp.dto';
import { EmailVerificationSender } from './email-verification.sender';

const otpLength = 6;
const otpExpiresInMinutes = 5;
const otpExpiresInMs = otpExpiresInMinutes * 60 * 1000;
const otpResendCooldownSeconds = 60;
const otpResendCooldownMs = otpResendCooldownSeconds * 1000;
const maxOtpAttempts = 5;
const maxOtpRequests = 5;
const unverifiedLoginMessage = 'Please verify your email before signing in.';

@Injectable()
export class AuthService {
  private readonly googleClient = new OAuth2Client();
  private readonly authConfig: ReturnType<typeof resolveAuthConfig>;

  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly emailVerificationSender: EmailVerificationSender,
  ) {
    this.authConfig = resolveAuthConfig(configService);
  }

  async checkEmailAvailability(
    checkEmailDto: CheckEmailDto,
  ): Promise<CheckEmailAvailabilityResponse> {
    const email = this.normalizeEmail(checkEmailDto.email);
    const existingUser = await this.userModel.findOne({ email }).exec();

    return { available: !existingUser };
  }

  async register(registerDto: RegisterDto): Promise<RegisterPendingResponse> {
    const email = this.normalizeEmail(registerDto.email);
    const displayName = registerDto.displayName.trim();
    const existingUser = await this.userModel.findOne({ email }).exec();

    if (existingUser?.verificationStatus === 'verified') {
      throw new ConflictException(
        'An account with this email already exists. Please sign in.',
      );
    }

    const passwordHash = await bcrypt.hash(registerDto.password, 10);
    const { otp, otpHash, verificationId, expiresAt, resendAvailableAt } =
      await this.createOtpState();

    let user = existingUser;
    if (user) {
      const requestCount = (user.emailOtpRequestCount ?? 0) + 1;
      if (requestCount > maxOtpRequests) {
        throw this.tooManyRequests(
          'Too many verification codes requested. Please try again later.',
        );
      }

      user.displayName = displayName;
      user.passwordHash = passwordHash;
      user.provider = 'password';
      user.verificationStatus = 'pending';
      user.emailVerifiedAt = undefined;
      user.emailOtpHash = otpHash;
      user.emailOtpExpiresAt = expiresAt;
      user.emailOtpResendAvailableAt = resendAvailableAt;
      user.emailOtpAttemptCount = 0;
      user.emailOtpRequestCount = requestCount;
      user.emailVerificationId = verificationId;
      await user.save();
    } else {
      user = await this.userModel.create({
        email,
        displayName,
        passwordHash,
        provider: 'password',
        verificationStatus: 'pending',
        emailOtpHash: otpHash,
        emailOtpExpiresAt: expiresAt,
        emailOtpResendAvailableAt: resendAvailableAt,
        emailOtpAttemptCount: 0,
        emailOtpRequestCount: 1,
        emailVerificationId: verificationId,
      });
    }

    await this.emailVerificationSender.sendOtp({
      email,
      displayName,
      otp,
      expiresInMinutes: otpExpiresInMinutes,
    });

    return this.toRegisterPendingResponse(user);
  }

  async verifyEmailOtp(
    verifyEmailOtpDto: VerifyEmailOtpDto,
  ): Promise<AuthSuccessResponse> {
    const user = await this.userModel
      .findOne({ emailVerificationId: verifyEmailOtpDto.verificationId })
      .exec();

    const pendingUser = this.ensurePendingVerificationUser(user);
    const attemptCount = pendingUser.emailOtpAttemptCount ?? 0;
    if (attemptCount >= maxOtpAttempts) {
      throw this.tooManyRequests(
        'Too many incorrect codes. Please request a new code.',
      );
    }

    if (
      !pendingUser.emailOtpExpiresAt ||
      pendingUser.emailOtpExpiresAt.getTime() <= Date.now()
    ) {
      throw new BadRequestException(
        'This verification code has expired. Request a new code to continue.',
      );
    }

    if (!pendingUser.emailOtpHash) {
      throw new BadRequestException(
        'Verification is unavailable. Please request a new code.',
      );
    }

    const otpMatches = await bcrypt.compare(
      verifyEmailOtpDto.otp,
      pendingUser.emailOtpHash,
    );

    if (!otpMatches) {
      pendingUser.emailOtpAttemptCount = attemptCount + 1;
      await pendingUser.save();

      if ((pendingUser.emailOtpAttemptCount ?? 0) >= maxOtpAttempts) {
        throw this.tooManyRequests(
          'Too many incorrect codes. Please request a new code.',
        );
      }

      throw new UnauthorizedException('That code does not look right yet.');
    }

    this.markEmailVerified(pendingUser);
    await pendingUser.save();
    return this.createAuthResponse(pendingUser);
  }

  async resendEmailOtp(
    resendEmailOtpDto: ResendEmailOtpDto,
  ): Promise<RegisterPendingResponse> {
    const user = await this.userModel
      .findOne({ emailVerificationId: resendEmailOtpDto.verificationId })
      .exec();

    const pendingUser = this.ensurePendingVerificationUser(user);
    const resendAvailableAt = pendingUser.emailOtpResendAvailableAt;
    if (resendAvailableAt && resendAvailableAt.getTime() > Date.now()) {
      const waitSeconds = Math.ceil(
        (resendAvailableAt.getTime() - Date.now()) / 1000,
      );
      throw this.tooManyRequests(
        `Please wait ${waitSeconds} seconds before requesting another code.`,
      );
    }

    const requestCount = (pendingUser.emailOtpRequestCount ?? 0) + 1;
    if (requestCount > maxOtpRequests) {
      throw this.tooManyRequests(
        'Too many verification codes requested. Please try again later.',
      );
    }

    const { otp, otpHash, verificationId, expiresAt, resendAvailableAt: next } =
      await this.createOtpState();

    pendingUser.emailOtpHash = otpHash;
    pendingUser.emailOtpExpiresAt = expiresAt;
    pendingUser.emailOtpResendAvailableAt = next;
    pendingUser.emailOtpAttemptCount = 0;
    pendingUser.emailOtpRequestCount = requestCount;
    pendingUser.emailVerificationId = verificationId;
    await pendingUser.save();

    await this.emailVerificationSender.sendOtp({
      email: pendingUser.email,
      displayName: pendingUser.displayName,
      otp,
      expiresInMinutes: otpExpiresInMinutes,
    });

    return this.toRegisterPendingResponse(pendingUser);
  }

  private tooManyRequests(message: string): HttpException {
    return new HttpException(message, 429);
  }

  async updateProfile(
    userId: string,
    updateProfileDto: UpdateProfileDto,
  ): Promise<AuthUserResponse> {
    const displayName = updateProfileDto.displayName.trim();

    if (displayName.length === 0) {
      throw new BadRequestException('Display name cannot be empty');
    }

    const user = await this.userModel.findById(userId).exec();

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    user.displayName = displayName;
    await user.save();

    return this.toAuthUser(user);
  }

  async login(loginDto: LoginDto): Promise<AuthSuccessResponse> {
    const email = this.normalizeEmail(loginDto.email);
    const user = await this.userModel.findOne({ email }).exec();

    if (!user?.passwordHash) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (user.verificationStatus !== 'verified') {
      throw new UnauthorizedException(unverifiedLoginMessage);
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

  async loginPendingVerification(
    loginDto: LoginDto,
  ): Promise<RegisterPendingResponse> {
    const email = this.normalizeEmail(loginDto.email);
    const user = await this.userModel.findOne({ email }).exec();

    if (!user?.passwordHash || user.provider !== 'password') {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (user.verificationStatus !== 'pending') {
      throw new UnauthorizedException(unverifiedLoginMessage);
    }

    return this.toRegisterPendingResponse(user);
  }

  private normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  async loginWithGoogle(
    googleLoginDto: GoogleLoginDto,
  ): Promise<AuthSuccessResponse> {
    const clientId = this.configService.get<string>('GOOGLE_CLIENT_ID');
    let payload: TokenPayload | undefined;

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
        verificationStatus: 'verified',
        emailVerifiedAt: new Date(),
        googleSub: payload.sub,
      });
    } else {
      user.email = email;
      user.displayName =
        payload.name?.trim() || user.displayName || fallbackDisplayName;
      user.avatarUrl = payload.picture ?? user.avatarUrl;
      user.googleSub = payload.sub;
      user.provider = 'google';
      this.markEmailVerified(user);
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

  private async createOtpState(): Promise<{
    otp: string;
    otpHash: string;
    verificationId: string;
    expiresAt: Date;
    resendAvailableAt: Date;
  }> {
    const otp = randomInt(0, 10 ** otpLength)
      .toString()
      .padStart(otpLength, '0');

    return {
      otp,
      otpHash: await bcrypt.hash(otp, 10),
      verificationId: randomUUID(),
      expiresAt: new Date(Date.now() + otpExpiresInMs),
      resendAvailableAt: new Date(Date.now() + otpResendCooldownMs),
    };
  }

  private ensurePendingVerificationUser(
    user: UserDocument | null,
  ): UserDocument {
    if (!user || user.verificationStatus !== 'pending') {
      throw new BadRequestException(
        'This verification request is no longer available.',
      );
    }

    return user;
  }

  private markEmailVerified(user: UserDocument) {
    user.verificationStatus = 'verified';
    user.emailVerifiedAt = new Date();
    user.emailOtpHash = undefined;
    user.emailOtpExpiresAt = undefined;
    user.emailOtpResendAvailableAt = undefined;
    user.emailOtpAttemptCount = undefined;
    user.emailOtpRequestCount = undefined;
    user.emailVerificationId = undefined;
  }

  private toRegisterPendingResponse(
    user: UserDocument,
  ): RegisterPendingResponse {
    if (!user.emailVerificationId) {
      throw new BadRequestException(
        'Verification is unavailable. Please try signing up again.',
      );
    }

    const resendAvailableInSeconds = Math.max(
      0,
      Math.ceil(
        ((user.emailOtpResendAvailableAt?.getTime() ?? Date.now()) -
          Date.now()) /
          1000,
      ),
    );

    return {
      verificationId: user.emailVerificationId,
      email: user.email,
      resendAvailableInSeconds,
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

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { InjectModel } from '@nestjs/mongoose';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Model } from 'mongoose';
import { JwtPayload } from './auth-user.types';
import { User, UserDocument } from './user.schema';
import { AuthService } from './auth.service';
import { resolveJwtAccessSecret } from '../../config/auth.config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    configService: ConfigService,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly authService: AuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: resolveJwtAccessSecret(
        configService.get<string>('JWT_ACCESS_SECRET'),
      ),
    });
  }

  async validate(payload: JwtPayload) {
    const user = await this.userModel.findById(payload.sub).exec();
    if (!user) {
      throw new UnauthorizedException('Invalid token');
    }

    return this.authService.toAuthUser(user);
  }
}

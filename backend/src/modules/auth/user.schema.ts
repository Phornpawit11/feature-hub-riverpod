import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { AuthProvider, EmailVerificationStatus } from './auth-user.types';

export type UserDocument = HydratedDocument<User>;

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true, unique: true, lowercase: true, trim: true })
  email: string;

  @Prop()
  passwordHash?: string;

  @Prop({ required: true, trim: true })
  displayName: string;

  @Prop()
  avatarUrl?: string;

  @Prop({ required: true, enum: ['password', 'google'] })
  provider: AuthProvider;

  @Prop({ required: true, enum: ['pending', 'verified'] })
  verificationStatus: EmailVerificationStatus;

  @Prop()
  emailVerifiedAt?: Date;

  @Prop()
  emailOtpHash?: string;

  @Prop()
  emailOtpExpiresAt?: Date;

  @Prop()
  emailOtpResendAvailableAt?: Date;

  @Prop({ default: 0 })
  emailOtpAttemptCount?: number;

  @Prop({ default: 0 })
  emailOtpRequestCount?: number;

  @Prop({ unique: true, sparse: true })
  emailVerificationId?: string;

  @Prop({ unique: true, sparse: true })
  googleSub?: string;

  @Prop()
  refreshTokenHash?: string;

  @Prop()
  refreshTokenExpiresAt?: Date;

  @Prop()
  refreshSessionId?: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

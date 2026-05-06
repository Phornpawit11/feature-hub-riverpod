import { IsString, Length } from 'class-validator';

export class VerifyEmailOtpDto {
  @IsString()
  @Length(1, 255)
  verificationId: string;

  @IsString()
  @Length(6, 6)
  otp: string;
}

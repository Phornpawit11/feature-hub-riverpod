import { IsString, Length } from 'class-validator';

export class ResendEmailOtpDto {
  @IsString()
  @Length(1, 255)
  verificationId: string;
}

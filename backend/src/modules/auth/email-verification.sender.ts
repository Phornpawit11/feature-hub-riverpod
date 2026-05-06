import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface SendEmailVerificationOtpParams {
  email: string;
  displayName: string;
  otp: string;
  expiresInMinutes: number;
}

export abstract class EmailVerificationSender {
  abstract sendOtp(params: SendEmailVerificationOtpParams): Promise<void>;
}

@Injectable()
export class LoggingEmailVerificationSender implements EmailVerificationSender {
  private readonly logger = new Logger(LoggingEmailVerificationSender.name);

  constructor(private readonly configService: ConfigService) {}

  async sendOtp({
    email,
    displayName,
    otp,
    expiresInMinutes,
  }: SendEmailVerificationOtpParams): Promise<void> {
    const nodeEnv = this.configService.get<string>('NODE_ENV');
    if (nodeEnv === 'production') {
      this.logger.warn(
        `No email provider configured. OTP email was not delivered for ${email}.`,
      );
      return;
    }

    this.logger.log(
      [
        'Mock email verification sender',
        `to=${email}`,
        `name=${displayName}`,
        `otp=${otp}`,
        `expiresInMinutes=${expiresInMinutes}`,
      ].join(' | '),
    );
  }
}

import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Test } from '@nestjs/testing';
import { getModelToken } from '@nestjs/mongoose';
import * as bcrypt from 'bcrypt';
import {
  beforeEach,
  describe,
  expect,
  it,
  jest,
} from '@jest/globals';
import { AuthController } from '../../src/modules/auth/auth.controller';
import { AuthService } from '../../src/modules/auth/auth.service';
import { User } from '../../src/modules/auth/user.schema';
import { LoginDto } from '../../src/modules/auth/dto/login.dto';
import { RefreshTokenDto } from '../../src/modules/auth/dto/refresh-token.dto';
import { LogoutDto } from '../../src/modules/auth/dto/logout.dto';

jest.mock('bcrypt', () => ({
  compare: jest.fn(),
  hash: jest.fn(),
}));

describe('AuthController (e2e)', () => {
  const mockedBcrypt = bcrypt as jest.Mocked<typeof bcrypt>;

  const userModel = {
    findOne: jest.fn(),
    findById: jest.fn(),
    updateOne: jest.fn(),
  };

  const jwtService = {
    signAsync: jest.fn(),
    verifyAsync: jest.fn(),
  };

  const configService = {
    get: jest.fn(),
  };

  let controller: AuthController;
  let validationPipe: ValidationPipe;

  beforeEach(async () => {
    jest.clearAllMocks();
    configService.get.mockImplementation((key: string) =>
      (
        {
          NODE_ENV: 'test',
          JWT_ACCESS_EXPIRES_IN: '15m',
          JWT_REFRESH_EXPIRES_IN: '30d',
        } as Record<string, string>
      )[key],
    );

    const moduleRef = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        AuthService,
        {
          provide: getModelToken(User.name),
          useValue: userModel,
        },
        {
          provide: JwtService,
          useValue: jwtService,
        },
        {
          provide: ConfigService,
          useValue: configService,
        },
      ],
    }).compile();

    controller = moduleRef.get(AuthController);
    validationPipe = new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    });
  });

  it('returns access and refresh tokens for valid login', async () => {
    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => ({
        id: 'user-1',
        email: 'test@example.com',
        passwordHash: 'hashed-password',
        displayName: 'Test User',
        avatarUrl: null,
        provider: 'password',
        refreshSessionId: 'session-1',
        save: jest.fn(),
      })),
    });
    mockedBcrypt.compare.mockResolvedValue(true as never);
    mockedBcrypt.hash.mockResolvedValue('hashed-refresh-token' as never);
    jwtService.signAsync
      .mockResolvedValueOnce('jwt-token' as never)
      .mockResolvedValueOnce('refresh-token' as never);
    jwtService.verifyAsync.mockResolvedValue({
      sid: 'session-1',
      exp: 2_000_000_000,
    } as never);

    const loginDto = (await validationPipe.transform(
      {
        email: 'test@example.com',
        password: 'password123',
      },
      {
        type: 'body',
        metatype: LoginDto,
      },
    )) as LoginDto;

    const response = await controller.login(loginDto);

    expect(response).toEqual({
      accessToken: 'jwt-token',
      refreshToken: 'refresh-token',
      user: {
        id: 'user-1',
        email: 'test@example.com',
        displayName: 'Test User',
        avatarUrl: null,
        provider: 'password',
      },
    });
    expect(userModel.findOne).toHaveBeenCalledWith({
      email: 'test@example.com',
    });
  });

  it('returns 401 for wrong password', async () => {
    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => ({
        id: 'user-1',
        email: 'test@example.com',
        passwordHash: 'hashed-password',
        displayName: 'Test User',
        provider: 'password',
        save: jest.fn(),
      })),
    });
    mockedBcrypt.compare.mockResolvedValue(false as never);

    const loginDto = (await validationPipe.transform(
      {
        email: 'test@example.com',
        password: 'wrong-password',
      },
      {
        type: 'body',
        metatype: LoginDto,
      },
    )) as LoginDto;

    await expect(controller.login(loginDto)).rejects.toMatchObject({
      status: 401,
      response: {
        message: 'Invalid email or password',
      },
    });
  });

  it('returns 400 for invalid payload', async () => {
    await expect(
      validationPipe.transform(
        {
          email: 'bad-email',
          password: '',
        },
        {
          type: 'body',
          metatype: LoginDto,
        },
      ),
    ).rejects.toMatchObject({
      status: 400,
      response: {
        message: expect.arrayContaining([
          expect.stringContaining('email'),
          expect.stringContaining('password'),
        ]),
      },
    });
  });

  it('accepts valid refresh payload shape', async () => {
    const refreshDto = (await validationPipe.transform(
      {
        refreshToken: 'refresh-token',
      },
      {
        type: 'body',
        metatype: RefreshTokenDto,
      },
    )) as RefreshTokenDto;

    expect(refreshDto).toEqual({ refreshToken: 'refresh-token' });
  });

  it('accepts valid logout payload shape', async () => {
    const logoutDto = (await validationPipe.transform(
      {
        refreshToken: 'refresh-token',
      },
      {
        type: 'body',
        metatype: LogoutDto,
      },
    )) as LogoutDto;

    expect(logoutDto).toEqual({ refreshToken: 'refresh-token' });
  });
});

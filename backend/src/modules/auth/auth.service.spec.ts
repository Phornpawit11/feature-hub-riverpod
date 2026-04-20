import { UnauthorizedException } from '@nestjs/common';
import {
  beforeEach,
  describe,
  expect,
  it,
  jest,
} from '@jest/globals';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';

jest.mock('bcrypt', () => ({
  compare: jest.fn(),
}));

describe('AuthService', () => {
  const mockedBcrypt = bcrypt as jest.Mocked<typeof bcrypt>;

  const userModel = {
    findOne: jest.fn(),
    create: jest.fn(),
  };

  const jwtService = {
    signAsync: jest.fn(),
  } as unknown as Pick<JwtService, 'signAsync'>;

  const configService = {
    get: jest.fn(),
  } as unknown as Pick<ConfigService, 'get'>;

  let service: AuthService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new AuthService(
      userModel as never,
      jwtService as JwtService,
      configService as ConfigService,
    );
  });

  it('returns access token and user for valid password login', async () => {
    const loginDto: LoginDto = {
      email: ' Test@Example.com ',
      password: 'password123',
    };
    const user = {
      id: 'user-1',
      email: 'test@example.com',
      passwordHash: 'hashed-password',
      displayName: 'Test User',
      avatarUrl: null,
      provider: 'password',
    };

    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => user),
    });
    mockedBcrypt.compare.mockResolvedValue(true as never);
    jwtService.signAsync = jest
      .fn<() => Promise<string>>()
      .mockResolvedValue('jwt-token');

    await expect(service.login(loginDto)).resolves.toEqual({
      accessToken: 'jwt-token',
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
    expect(mockedBcrypt.compare).toHaveBeenCalledWith(
      'password123',
      'hashed-password',
    );
  });

  it('throws unauthorized when email is not found', async () => {
    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => null),
    });

    await expect(
      service.login({
        email: 'missing@example.com',
        password: 'password123',
      }),
    ).rejects.toThrow(
      new UnauthorizedException('Invalid email or password'),
    );
  });

  it('throws unauthorized when password is invalid', async () => {
    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => ({
        id: 'user-1',
        email: 'test@example.com',
        passwordHash: 'hashed-password',
        displayName: 'Test User',
        provider: 'password',
      })),
    });
    mockedBcrypt.compare.mockResolvedValue(false as never);

    await expect(
      service.login({
        email: 'test@example.com',
        password: 'wrong-password',
      }),
    ).rejects.toThrow(
      new UnauthorizedException('Invalid email or password'),
    );
  });
});

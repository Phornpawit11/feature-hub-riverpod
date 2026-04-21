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
  hash: jest.fn(),
}));

describe('AuthService', () => {
  const mockedBcrypt = bcrypt as jest.Mocked<typeof bcrypt>;

  const userModel = {
    findOne: jest.fn(),
    findById: jest.fn(),
    create: jest.fn(),
    updateOne: jest.fn(),
  };

  const jwtService = {
    signAsync: jest.fn(),
    verifyAsync: jest.fn(),
  } as unknown as Pick<JwtService, 'signAsync' | 'verifyAsync'>;

  const configService = {
    get: jest.fn(),
  } as unknown as Pick<ConfigService, 'get'>;

  let service: AuthService;

  beforeEach(() => {
    jest.clearAllMocks();
    configService.get = jest.fn((key: string) =>
      (
        {
          NODE_ENV: 'test',
          JWT_ACCESS_EXPIRES_IN: '15m',
          JWT_REFRESH_EXPIRES_IN: '30d',
        } as Record<string, string>
      )[key],
    ) as never;
    service = new AuthService(
      userModel as never,
      jwtService as JwtService,
      configService as ConfigService,
    );
  });

  it('returns access and refresh tokens for valid password login', async () => {
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
      save: jest.fn(),
    };

    userModel.findOne.mockReturnValue({
      exec: jest.fn().mockImplementation(async () => user),
    });
    mockedBcrypt.compare.mockResolvedValue(true as never);
    mockedBcrypt.hash.mockResolvedValue('hashed-refresh-token' as never);
    jwtService.signAsync = jest
      .fn<() => Promise<string>>()
      .mockResolvedValueOnce('jwt-token' as never)
      .mockResolvedValueOnce('refresh-token' as never);
    (jwtService.verifyAsync as jest.Mock).mockResolvedValue({
      sid: 'session-1',
      exp: 2_000_000_000,
    } as never);

    await expect(service.login(loginDto)).resolves.toEqual({
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
    expect(mockedBcrypt.compare).toHaveBeenCalledWith(
      'password123',
      'hashed-password',
    );
    expect(mockedBcrypt.hash).toHaveBeenCalledWith('refresh-token', 10);
    expect(user.save).toHaveBeenCalled();
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
        save: jest.fn(),
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

  it('returns rotated tokens for a valid refresh token', async () => {
    const user = {
      id: 'user-1',
      email: 'test@example.com',
      passwordHash: 'hashed-password',
      displayName: 'Test User',
      avatarUrl: null,
      provider: 'password',
      refreshSessionId: 'session-1',
      refreshTokenHash: 'stored-refresh-hash',
      refreshTokenExpiresAt: new Date(Date.now() + 60_000),
      save: jest.fn(),
    };
    userModel.findById.mockReturnValue({
      exec: jest.fn().mockResolvedValue(user as never),
    });
    (jwtService.verifyAsync as jest.Mock)
      .mockResolvedValueOnce({
        sub: 'user-1',
        email: 'test@example.com',
        sid: 'session-1',
        exp: 2_000_000_000,
      } as never)
      .mockResolvedValueOnce({
        sub: 'user-1',
        email: 'test@example.com',
        sid: 'session-2',
        exp: 2_000_000_000,
      } as never);
    mockedBcrypt.compare.mockResolvedValue(true as never);
    mockedBcrypt.hash.mockResolvedValue('rotated-refresh-hash' as never);
    userModel.updateOne.mockResolvedValue({ modifiedCount: 1 } as never);
    jwtService.signAsync = jest
      .fn<() => Promise<string>>()
      .mockResolvedValueOnce('new-access-token' as never)
      .mockResolvedValueOnce('new-refresh-token' as never);

    await expect(
      service.refresh({ refreshToken: 'valid-refresh-token' }),
    ).resolves.toEqual({
      accessToken: 'new-access-token',
      refreshToken: 'new-refresh-token',
      user: {
        id: 'user-1',
        email: 'test@example.com',
        displayName: 'Test User',
        avatarUrl: null,
        provider: 'password',
      },
    });

    expect(mockedBcrypt.compare).toHaveBeenCalledWith(
      'valid-refresh-token',
      'stored-refresh-hash',
    );
    expect(userModel.updateOne).toHaveBeenCalledWith(
      {
        _id: 'user-1',
        refreshSessionId: 'session-1',
        refreshTokenHash: 'stored-refresh-hash',
      },
      {
        $set: {
          refreshSessionId: expect.any(String),
          refreshTokenHash: 'rotated-refresh-hash',
          refreshTokenExpiresAt: expect.any(Date),
        },
      },
    );
  });

  it('throws unauthorized when a concurrent refresh already rotated the session', async () => {
    const user = {
      id: 'user-1',
      email: 'test@example.com',
      displayName: 'Test User',
      avatarUrl: null,
      provider: 'password',
      refreshSessionId: 'session-1',
      refreshTokenHash: 'stored-refresh-hash',
      refreshTokenExpiresAt: new Date(Date.now() + 60_000),
    };

    userModel.findById.mockReturnValue({
      exec: jest.fn().mockResolvedValue(user as never),
    });
    (jwtService.verifyAsync as jest.Mock)
      .mockResolvedValueOnce({
        sub: 'user-1',
        email: 'test@example.com',
        sid: 'session-1',
        exp: 2_000_000_000,
      } as never)
      .mockResolvedValueOnce({
        sub: 'user-1',
        email: 'test@example.com',
        sid: 'session-2',
        exp: 2_000_000_000,
      } as never);
    mockedBcrypt.compare.mockResolvedValue(true as never);
    mockedBcrypt.hash.mockResolvedValue('rotated-refresh-hash' as never);
    userModel.updateOne.mockResolvedValue({ modifiedCount: 0 } as never);
    jwtService.signAsync = jest
      .fn<() => Promise<string>>()
      .mockResolvedValueOnce('new-access-token' as never)
      .mockResolvedValueOnce('new-refresh-token' as never);

    await expect(
      service.refresh({ refreshToken: 'valid-refresh-token' }),
    ).rejects.toThrow(
      new UnauthorizedException('Invalid refresh token'),
    );
  });

  it('throws unauthorized when logout token is invalid or revoked', async () => {
    (jwtService.verifyAsync as jest.Mock).mockResolvedValue({
      sub: 'user-1',
      email: 'test@example.com',
      sid: 'session-1',
      exp: 2_000_000_000,
    } as never);
    userModel.findById.mockReturnValue({
      exec: jest.fn().mockResolvedValue({
        id: 'user-1',
        refreshSessionId: 'another-session',
        refreshTokenHash: 'stored-refresh-hash',
        refreshTokenExpiresAt: new Date(Date.now() + 60_000),
      } as never),
    });

    await expect(
      service.logout({ refreshToken: 'invalid-refresh-token' }),
    ).rejects.toThrow(
      new UnauthorizedException('Invalid refresh token'),
    );
  });

  it('revokes the active session on valid logout', async () => {
    const user = {
      id: 'user-1',
      refreshSessionId: 'session-1',
      refreshTokenHash: 'stored-refresh-hash',
      refreshTokenExpiresAt: new Date(Date.now() + 60_000),
    };

    (jwtService.verifyAsync as jest.Mock).mockResolvedValue({
      sub: 'user-1',
      email: 'test@example.com',
      sid: 'session-1',
      exp: 2_000_000_000,
    } as never);
    userModel.findById.mockReturnValue({
      exec: jest.fn().mockResolvedValue(user as never),
    });
    mockedBcrypt.compare.mockResolvedValue(true as never);
    userModel.updateOne.mockResolvedValue({ modifiedCount: 1 } as never);

    await expect(
      service.logout({ refreshToken: 'valid-refresh-token' }),
    ).resolves.toEqual({ success: true });

    expect(userModel.updateOne).toHaveBeenCalledWith(
      {
        _id: 'user-1',
        refreshSessionId: 'session-1',
        refreshTokenHash: 'stored-refresh-hash',
      },
      {
        $unset: {
          refreshSessionId: 1,
          refreshTokenHash: 1,
          refreshTokenExpiresAt: 1,
        },
      },
    );
  });
});

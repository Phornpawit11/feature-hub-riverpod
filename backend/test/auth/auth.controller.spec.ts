import {
  beforeEach,
  describe,
  expect,
  it,
  jest,
} from '@jest/globals';
import { AuthController } from '../../src/modules/auth/auth.controller';
import { AuthService } from '../../src/modules/auth/auth.service';
import { LoginDto } from '../../src/modules/auth/dto/login.dto';
import { GoogleLoginDto } from '../../src/modules/auth/dto/google-login.dto';
import { RefreshTokenDto } from '../../src/modules/auth/dto/refresh-token.dto';
import { LogoutDto } from '../../src/modules/auth/dto/logout.dto';

describe('AuthController', () => {
  const authService = {
    login: jest.fn(),
    loginWithGoogle: jest.fn(),
    refresh: jest.fn(),
    logout: jest.fn(),
  } as unknown as jest.Mocked<AuthService>;

  let controller: AuthController;

  beforeEach(() => {
    jest.clearAllMocks();
    controller = new AuthController(authService);
  });

  it('delegates login to auth service', async () => {
    const loginDto: LoginDto = {
      email: 'test@example.com',
      password: 'password123',
    };
    const response = {
      accessToken: 'jwt-token',
      refreshToken: 'refresh-token',
      user: {
        id: 'user-1',
        email: 'test@example.com',
        displayName: 'Test User',
        provider: 'password',
        avatarUrl: null,
      },
    };

    authService.login.mockResolvedValue(response as never);

    await expect(controller.login(loginDto)).resolves.toEqual(response);
    expect(authService.login).toHaveBeenCalledWith(loginDto);
  });

  it('delegates google login to auth service', async () => {
    const googleLoginDto: GoogleLoginDto = {
      idToken: 'google-id-token',
    };
    const response = {
      accessToken: 'jwt-token',
      refreshToken: 'refresh-token',
      user: {
        id: 'user-1',
        email: 'test@example.com',
        displayName: 'Test User',
        provider: 'google',
        avatarUrl: null,
      },
    };

    authService.loginWithGoogle.mockResolvedValue(response as never);

    await expect(controller.loginWithGoogle(googleLoginDto)).resolves.toEqual(
      response,
    );
    expect(authService.loginWithGoogle).toHaveBeenCalledWith(googleLoginDto);
  });

  it('delegates refresh to auth service', async () => {
    const refreshTokenDto: RefreshTokenDto = {
      refreshToken: 'refresh-token',
    };
    const response = {
      accessToken: 'new-access-token',
      refreshToken: 'new-refresh-token',
      user: {
        id: 'user-1',
        email: 'test@example.com',
        displayName: 'Test User',
        provider: 'password',
        avatarUrl: null,
      },
    };

    authService.refresh.mockResolvedValue(response as never);

    await expect(controller.refresh(refreshTokenDto)).resolves.toEqual(response);
    expect(authService.refresh).toHaveBeenCalledWith(refreshTokenDto);
  });

  it('delegates logout to auth service', async () => {
    const logoutDto: LogoutDto = {
      refreshToken: 'refresh-token',
    };

    authService.logout.mockResolvedValue({ success: true } as never);

    await expect(controller.logout(logoutDto)).resolves.toEqual({
      success: true,
    });
    expect(authService.logout).toHaveBeenCalledWith(logoutDto);
  });

  it('surfaces logout auth failures from auth service', async () => {
    const logoutDto: LogoutDto = {
      refreshToken: 'expired-refresh-token',
    };

    authService.logout.mockRejectedValue(new Error('Invalid refresh token'));

    await expect(controller.logout(logoutDto)).rejects.toThrow(
      'Invalid refresh token',
    );
  });

  it('returns current user from request in me endpoint', () => {
    const user = {
      id: 'user-1',
      email: 'test@example.com',
      displayName: 'Test User',
      provider: 'password',
      avatarUrl: null,
    };

    const request = { user } as never;

    expect(controller.me(request)).toEqual(user);
  });
});

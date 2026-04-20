export type AuthProvider = 'password' | 'google';

export interface AuthUserResponse {
  id: string;
  email: string;
  displayName: string;
  avatarUrl?: string | null;
  provider: AuthProvider;
}

export interface AuthSuccessResponse {
  accessToken: string;
  refreshToken: string;
  user: AuthUserResponse;
}

export interface LogoutResponse {
  success: boolean;
}

export interface JwtPayload {
  sub: string;
  email: string;
}

export interface JwtPayloadWithExpiry extends JwtPayload {
  exp?: number;
  iat?: number;
}

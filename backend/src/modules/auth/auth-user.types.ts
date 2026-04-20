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
  user: AuthUserResponse;
}

export interface JwtPayload {
  sub: string;
  email: string;
}

export const defaultJwtAccessSecret = 'dev-jwt-access-secret-change-me';
export const defaultJwtRefreshSecret = 'dev-jwt-refresh-secret-change-me';
export const defaultJwtAccessExpiresIn = '15m';
export const defaultJwtRefreshExpiresIn = '30d';

export function resolveJwtAccessSecret(jwtSecret?: string): string {
  return jwtSecret || defaultJwtAccessSecret;
}

export function resolveJwtRefreshSecret(jwtSecret?: string): string {
  return jwtSecret || defaultJwtRefreshSecret;
}

export function resolveJwtAccessExpiresIn(expiresIn?: string): string {
  return expiresIn || defaultJwtAccessExpiresIn;
}

export function resolveJwtRefreshExpiresIn(expiresIn?: string): string {
  return expiresIn || defaultJwtRefreshExpiresIn;
}

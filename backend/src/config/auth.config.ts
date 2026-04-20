export const defaultJwtSecret = 'dev-jwt-secret-change-me';

export function resolveJwtSecret(jwtSecret?: string): string {
  return jwtSecret || defaultJwtSecret;
}

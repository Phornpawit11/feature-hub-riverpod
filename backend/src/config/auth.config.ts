type ConfigReader = {
  get<T = string>(key: string): T | undefined;
};

export const defaultJwtAccessSecret = 'dev-jwt-access-secret-change-me';
export const defaultJwtRefreshSecret = 'dev-jwt-refresh-secret-change-me';
export const defaultJwtAccessExpiresIn = '15m';
export const defaultJwtRefreshExpiresIn = '30d';

const explicitLocalNodeEnvs = new Set(['development', 'dev', 'local', 'test']);

export class AuthConfigError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AuthConfigError';
  }
}

export interface ResolvedAuthConfig {
  accessSecret: string;
  refreshSecret: string;
  accessExpiresIn: string;
  refreshExpiresIn: string;
}

export function resolveJwtAccessExpiresIn(expiresIn?: string): string {
  return expiresIn || defaultJwtAccessExpiresIn;
}

export function resolveJwtRefreshExpiresIn(expiresIn?: string): string {
  return expiresIn || defaultJwtRefreshExpiresIn;
}

export function resolveAuthConfig(config: ConfigReader): ResolvedAuthConfig {
  const nodeEnv = config.get<string>('NODE_ENV');
  const legacyJwtSecret = config.get<string>('JWT_SECRET');

  return {
    accessSecret: resolveSecretValue({
      configuredValue: config.get<string>('JWT_ACCESS_SECRET'),
      legacyValue: legacyJwtSecret,
      fallbackValue: defaultJwtAccessSecret,
      fallbackLabel: 'JWT_ACCESS_SECRET or JWT_SECRET',
      nodeEnv,
    }),
    refreshSecret: resolveSecretValue({
      configuredValue: config.get<string>('JWT_REFRESH_SECRET'),
      legacyValue: legacyJwtSecret,
      fallbackValue: defaultJwtRefreshSecret,
      fallbackLabel: 'JWT_REFRESH_SECRET or JWT_SECRET',
      nodeEnv,
    }),
    accessExpiresIn: resolveJwtAccessExpiresIn(
      config.get<string>('JWT_ACCESS_EXPIRES_IN'),
    ),
    refreshExpiresIn: resolveJwtRefreshExpiresIn(
      config.get<string>('JWT_REFRESH_EXPIRES_IN'),
    ),
  };
}

function resolveSecretValue({
  configuredValue,
  legacyValue,
  fallbackValue,
  fallbackLabel,
  nodeEnv,
}: {
  configuredValue?: string;
  legacyValue?: string;
  fallbackValue: string;
  fallbackLabel: string;
  nodeEnv?: string;
}): string {
  if (configuredValue) {
    return configuredValue;
  }

  if (legacyValue) {
    return legacyValue;
  }

  if (nodeEnv && explicitLocalNodeEnvs.has(nodeEnv)) {
    return fallbackValue;
  }

  throw new AuthConfigError(
    `Missing JWT configuration. Set ${fallbackLabel}.`,
  );
}

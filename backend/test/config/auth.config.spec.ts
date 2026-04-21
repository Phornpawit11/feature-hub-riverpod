import {
  describe,
  expect,
  it,
} from '@jest/globals';
import {
  AuthConfigError,
  defaultJwtAccessSecret,
  defaultJwtRefreshSecret,
  resolveAuthConfig,
} from '../../src/config/auth.config';

describe('resolveAuthConfig', () => {
  it('falls back to legacy JWT_SECRET during migration', () => {
    const config = {
      get: (key: string) => {
        if (key === 'JWT_SECRET') return 'legacy-secret';
        return undefined;
      },
    } as const;

    expect(resolveAuthConfig(config as never)).toMatchObject({
      accessSecret: 'legacy-secret',
      refreshSecret: 'legacy-secret',
    });
  });

  it('prefers new access and refresh secrets over legacy JWT_SECRET', () => {
    const config = {
      get: (key: string) =>
        ({
          JWT_ACCESS_SECRET: 'access-secret',
          JWT_REFRESH_SECRET: 'refresh-secret',
          JWT_SECRET: 'legacy-secret',
        })[key],
    } as const;

    expect(resolveAuthConfig(config as never)).toMatchObject({
      accessSecret: 'access-secret',
      refreshSecret: 'refresh-secret',
    });
  });

  it('uses dev defaults only in explicit local development mode', () => {
    const config = {
      get: (key: string) => {
        if (key === 'NODE_ENV') return 'development';
        return undefined;
      },
    } as const;

    expect(resolveAuthConfig(config as never)).toMatchObject({
      accessSecret: defaultJwtAccessSecret,
      refreshSecret: defaultJwtRefreshSecret,
    });
  });

  it('throws when secrets are missing outside explicit local dev', () => {
    const config = {
      get: (_key: string) => undefined,
    } as const;

    expect(() => resolveAuthConfig(config as never)).toThrow(AuthConfigError);
  });
});

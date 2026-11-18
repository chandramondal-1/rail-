import 'dotenv/config';

function truthy(value) {
  return /^(1|true|yes|on)$/i.test(String(value ?? '').trim());
}

const railkitKey = (process.env.RAILKIT_API_KEY ?? '').trim();
const irctcKey = (process.env.IRCTC_API_KEY ?? '').trim();
const requested = (process.env.RAILWAY_PROVIDER ?? '').trim().toLowerCase();

const provider =
  requested === 'railkit' || requested === 'irctc'
    ? requested
    : railkitKey
      ? 'railkit'
      : 'irctc';

const activeKey = provider === 'railkit' ? railkitKey : irctcKey;
const demoForced = truthy(process.env.RAILPULSE_DEMO);

export const env = {
  port: Number.parseInt(process.env.PORT ?? '8787', 10) || 8787,
  provider,
  railkitKey,
  irctcKey,
  irctcBaseUrl: process.env.IRCTC_BASE_URL ?? 'https://api.irctc.dev',
  demoForced,
  demo: demoForced || activeKey.length === 0,
  corsOrigin: process.env.CORS_ORIGIN ?? '*',
};

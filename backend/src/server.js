import express from 'express';
import cors from 'cors';
import { api } from './routes/api.js';
import { env } from './env.js';
import { ApiError } from './errors.js';

const app = express();

app.disable('x-powered-by');
app.use(
  cors({
    origin: env.corsOrigin === '*' ? true : env.corsOrigin.split(','),
  }),
);
app.use(express.json({ limit: '32kb' }));

app.get('/', (req, res) => {
  res.type('text/plain').send(
    [
      'RailPulse API proxy',
      `mode: ${env.demo ? 'demo' : 'live'}`,
      '',
      'GET /api/health',
      'GET /api/popular',
      'GET /api/trains/search?q=rajdhani',
      'GET /api/trains/:number',
      'GET /api/trains/:number/live?date=DD-MM-YYYY',
      'GET /api/pnr/:pnr',
      'GET /api/stations/search?q=new delhi',
      'GET /api/stations/:code/board?hours=2',
    ].join('\n'),
  );
});

app.use('/api', api);

app.use((req, res) => {
  res.status(404).json({
    error: {
      code: 'not_found',
      message: `No route for ${req.method} ${req.path}`,
    },
  });
});

app.use((error, req, res, next) => {
  if (res.headersSent) return next(error);

  if (error instanceof ApiError) {
    return res.status(error.status).json({
      error: { code: error.code, message: error.message },
    });
  }

  const message =
    error instanceof Error ? error.message : 'Unexpected server error';
  console.error('[railpulse]', message);
  return res.status(500).json({
    error: { code: 'internal_error', message: 'Unexpected server error' },
  });
});

app.listen(env.port, '0.0.0.0', () => {
  console.log(
    `RailPulse API listening on http://localhost:${env.port} (${env.demo ? 'DEMO MODE' : `LIVE via ${env.provider}`})`,
  );
  if (env.demo) {
    console.log(
      'No API key for the selected provider — responses are labelled source:"demo" and are sample data.',
    );
  }
});

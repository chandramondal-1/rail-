import { Router } from 'express';
import { badRequest } from '../errors.js';
import { cached } from '../cache.js';
import { env } from '../env.js';
import { provider, source } from '../railway/index.js';

export const api = Router();

const MINUTE = 60 * 1000;
const HOUR = 60 * MINUTE;

function respond(res, payload) {
  res.set('X-RailPulse-Source', source);
  res.set('Cache-Control', 'no-store');
  res.json({ source, ...payload });
}

function query(text, minimum = 2) {
  const value = String(text ?? '').trim();
  if (value.length < minimum) {
    throw badRequest(`Enter at least ${minimum} characters.`);
  }
  return value;
}

function trainNumber(value) {
  const number = String(value ?? '').trim();
  if (!/^\d{4,5}$/.test(number)) {
    throw badRequest('Train number must be 4 or 5 digits.');
  }
  return number;
}

function stationCode(value) {
  const code = String(value ?? '').trim().toUpperCase();
  if (!/^[A-Z0-9]{1,5}$/.test(code)) {
    throw badRequest('Enter a valid station code, for example NDLS.');
  }
  return code;
}

function journeyDate(value) {
  if (!value) return todayIst();
  const text = String(value).trim();
  const match = /^(\d{2})-(\d{2})-(\d{4})$/.exec(text);
  if (!match) throw badRequest('Date must use DD-MM-YYYY format.');
  const day = Number(match[1]);
  const month = Number(match[2]);
  const year = Number(match[3]);
  const parsed = new Date(year, month - 1, day);
  if (
    parsed.getFullYear() !== year ||
    parsed.getMonth() !== month - 1 ||
    parsed.getDate() !== day
  ) {
    throw badRequest('That date does not exist.');
  }
  return text;
}

function hours(value) {
  const parsed = Number.parseInt(String(value ?? '2'), 10);
  return [2, 4, 8].includes(parsed) ? parsed : 2;
}

function todayIst() {
  const parts = new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Asia/Kolkata',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  }).format(new Date());
  return parts.split('/').join('-');
}

api.get('/health', (req, res) => {
  respond(res, {
    ok: true,
    mode: source,
    provider: env.provider,
    demo: source === 'demo',
    time: new Date().toISOString(),
  });
});

api.get('/popular', async (req, res, next) => {
  try {
    const trains = await cached('popular', 6 * HOUR, () =>
      provider.getPopularTrains(),
    );
    respond(res, { trains });
  } catch (error) {
    next(error);
  }
});

api.get('/trains/search', async (req, res, next) => {
  try {
    const q = query(req.query.q);
    const results = await cached(`train-search:${q.toLowerCase()}`, 5 * MINUTE, () =>
      provider.searchTrains(q),
    );
    respond(res, { results });
  } catch (error) {
    next(error);
  }
});

api.get('/trains/:number', async (req, res, next) => {
  try {
    const number = trainNumber(req.params.number);
    const data = await cached(`train:${number}`, 6 * HOUR, () =>
      provider.getTrain(number),
    );
    respond(res, data);
  } catch (error) {
    next(error);
  }
});

api.get('/trains/:number/live', async (req, res, next) => {
  try {
    const number = trainNumber(req.params.number);
    const date = journeyDate(req.query.date);
    const live = await cached(`live:${number}:${date}`, 45 * 1000, () =>
      provider.getLive(number, date),
    );
    respond(res, { live });
  } catch (error) {
    next(error);
  }
});

api.get('/pnr/:pnr', async (req, res, next) => {
  try {
    const pnr = String(req.params.pnr ?? '').replace(/\D/g, '');
    if (pnr.length !== 10) throw badRequest('PNR number must be exactly 10 digits.');
    const pnrStatus = await cached(`pnr:${pnr}`, 2 * MINUTE, () =>
      provider.getPnr(pnr),
    );
    respond(res, { pnr: pnrStatus });
  } catch (error) {
    next(error);
  }
});

api.get('/stations/search', async (req, res, next) => {
  try {
    const q = query(req.query.q);
    const results = await cached(`station-search:${q.toLowerCase()}`, HOUR, () =>
      provider.searchStations(q),
    );
    respond(res, { results });
  } catch (error) {
    next(error);
  }
});

api.get('/stations/:code/board', async (req, res, next) => {
  try {
    const code = stationCode(req.params.code);
    const windowHours = hours(req.query.hours);
    const board = await cached(`board:${code}:${windowHours}`, MINUTE, () =>
      provider.getStationBoard(code, windowHours),
    );
    respond(res, { board });
  } catch (error) {
    next(error);
  }
});

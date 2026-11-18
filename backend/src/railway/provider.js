import {
  checkPNRStatus,
  configure,
  getTrainInfo,
  liveAtStation,
  stationByCode,
  stationsByName,
  trackTrain,
  trainByNumber,
  trainsByName,
} from 'railkit';
import { env } from '../env.js';
import {
  ApiError,
  notFound,
  upstreamError,
} from '../errors.js';
import {
  normalizeLive,
  normalizePnr,
  normalizeRoute,
  normalizeStationBoard,
  normalizeTrainProfile,
} from '../normalize.js';

let configured = false;

function ensureConfigured() {
  if (!configured) {
    configure(env.apiKey);
    configured = true;
  }
}

async function call(fn, ...args) {
  ensureConfigured();
  let result;
  try {
    result = await fn(...args);
  } catch (error) {
    throw upstreamError(error?.message ?? 'Railway provider request failed');
  }

  if (!result || result.success === false) {
    const message = String(result?.error ?? 'Railway provider request failed');
    if (/api key|not configured|inactive/i.test(message)) {
      throw new ApiError(
        503,
        'provider_unavailable',
        `Railway provider is not available: ${message}`,
      );
    }
    if (/not found|no .*found|invalid train|invalid station/i.test(message)) {
      throw notFound(message);
    }
    throw upstreamError(message);
  }

  return result.data;
}

function searchResult(train) {
  return {
    number: String(train.trainNo ?? ''),
    name: String(train.trainName ?? ''),
    type: null,
    source: null,
    sourceName: null,
    destination: null,
    destinationName: null,
  };
}

export async function searchTrains(query) {
  const trimmed = String(query ?? '').trim();
  const data = /^\d{2,5}$/.test(trimmed)
    ? await call(trainByNumber, trimmed)
    : await call(trainsByName, trimmed);
  const trains = Array.isArray(data?.trains) ? data.trains : [];
  return trains.map(searchResult);
}

export async function searchStations(query) {
  const data = await call(stationsByName, String(query ?? '').trim());
  const stations = Array.isArray(data?.stations) ? data.stations : [];
  return stations.map((station) => ({
    code: String(station.code ?? ''),
    name: String(station.name ?? ''),
    city: null,
  }));
}

export async function getTrain(number) {
  const data = await call(getTrainInfo, String(number));
  const train = normalizeTrainProfile(data?.trainInfo ?? {});
  const route = normalizeRoute(data?.route ?? []);
  if (!train.distanceKm && route.length > 0) {
    train.distanceKm = route[route.length - 1].distanceKm;
  }
  return { train, route };
}

export async function getLive(number, date) {
  const data = await call(trackTrain, String(number), date);
  return normalizeLive(data ?? {});
}

export async function getPnr(pnr) {
  const data = await call(checkPNRStatus, String(pnr));
  return normalizePnr(data ?? {});
}

export async function getStationBoard(code, hours) {
  const stationCode = String(code ?? '').toUpperCase();
  const [data, info] = await Promise.all([
    call(liveAtStation, stationCode, hours),
    call(stationByCode, stationCode).catch(() => null),
  ]);
  const board = normalizeStationBoard(data ?? {});
  board.station = {
    code: stationCode,
    name: info?.name ?? board.station.name ?? stationCode,
    city: null,
  };
  return board;
}

export async function getPopularTrains() {
  const numbers = ['12951', '12301', '12002', '12627'];
  const entries = await Promise.all(
    numbers.map((number) => getTrainByNumberForPopular(number)),
  );
  return entries.map((entry) => entry.train);
}

import { env } from '../env.js';
import { ApiError, notFound, upstreamError } from '../errors.js';
import {
  normalizeLive,
  normalizePnr,
  normalizeRoute,
  normalizeStationBoard,
  normalizeTrainProfile,
} from '../normalize.js';

const POPULAR_TRAINS = ['12951', '12301', '12002', '12627'];

let sdkPromise;
let configured = false;

/**
 * RailKit is an optional provider. Keeping the SDK as a dynamic import means
 * the proxy installs and runs with the default irctc.dev provider even when
 * the RailKit package is not installed.
 */
async function sdk() {
  if (!sdkPromise) {
    sdkPromise = import('railkit').catch(() => {
      sdkPromise = undefined;
      throw new ApiError(
        503,
        'provider_unavailable',
        'The RailKit SDK is not installed. Run "npm install railkit" in backend/ or switch RAILWAY_PROVIDER to irctc.',
      );
    });
  }
  const module = await sdkPromise;
  if (!configured) {
    module.configure(env.railkitKey);
    configured = true;
  }
  return module;
}

async function call(fn, ...args) {
  const api = await sdk();
  let result;
  try {
    result = await fn(api, ...args);
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
    type: train.trainType ?? null,
    source: train.from ?? null,
    sourceName: null,
    destination: train.to ?? null,
    destinationName: null,
    departure: null,
    arrival: null,
    duration: null,
    runningDays: null,
    distanceKm: Number.parseFloat(train.distance ?? train.distanceKm ?? 0) || 0,
  };
}

export async function searchTrains(query) {
  const trimmed = String(query ?? '').trim();
  const data = /^\d{4,5}$/.test(trimmed)
    ? await call((api, number) => api.trainByNumber(number), trimmed)
    : await call((api, name) => api.trainsByName(name), trimmed);
  const trains = Array.isArray(data?.trains) ? data.trains : [];
  return trains.map(searchResult);
}

export async function searchStations(query) {
  const data = await call(
    (api, name) => api.stationsByName(name),
    String(query ?? '').trim(),
  );
  const stations = Array.isArray(data?.stations) ? data.stations : [];
  return stations.map((station) => ({
    code: String(station.code ?? ''),
    name: String(station.name ?? ''),
    city: null,
  }));
}

export async function getTrain(number) {
  const data = await call((api, value) => api.getTrainInfo(value), String(number));
  const train = normalizeTrainProfile(data?.trainInfo ?? {});
  const route = normalizeRoute(data?.route ?? []);
  if (!train.distanceKm && route.length > 0) {
    train.distanceKm = route[route.length - 1].distanceKm;
  }
  return { train, route };
}

export async function getLive(number, date) {
  const data = await call(
    (api, value, day) => api.trackTrain(value, day),
    String(number),
    date,
  );
  return normalizeLive(data ?? {});
}

export async function getPnr(pnr) {
  const data = await call((api, value) => api.checkPNRStatus(value), String(pnr));
  return normalizePnr(data ?? {});
}

export async function getStationBoard(code, hours) {
  const stationCode = String(code ?? '').toUpperCase();
  const [data, info] = await Promise.all([
    call((api, value, window) => api.liveAtStation(value, window), stationCode, hours),
    call((api, value) => api.stationByCode(value), stationCode).catch(() => null),
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
  const results = await Promise.all(
    POPULAR_TRAINS.map((number) =>
      getTrain(number)
        .then((entry) => entry.train)
        .catch(() => null),
    ),
  );
  return results.filter(Boolean);
}

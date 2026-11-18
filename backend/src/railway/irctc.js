import { env } from '../env.js';
import { ApiError, notFound, upstreamError } from '../errors.js';

const MONTHS = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const POPULAR_TRAINS = ['12951', '12301', '12002', '12627'];

function toIso(value) {
  if (!value) return null;
  const text = String(value).trim().replace(/,$/, '');
  const match =
    /^(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\s+(\d{1,2}):(\d{2})$/.exec(text);
  if (match) {
    const month = MONTHS.findIndex(
      (name) => name.toLowerCase() === match[2].toLowerCase(),
    );
    if (month >= 0) {
      return new Date(
        Number(match[3]),
        month,
        Number(match[1]),
        Number(match[4]),
        Number(match[5]),
      ).toISOString();
    }
  }
  const parsed = new Date(text);
  return Number.isNaN(parsed.getTime()) ? text : parsed.toISOString();
}

function number(value, fallback = 0) {
  const parsed = Number.parseFloat(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function minutesToClock(base, delayMinutes) {
  if (!base || base === '--') return base;
  const match = /^(\d{1,2}):(\d{2})$/.exec(String(base));
  if (!match) return base;
  const total = (((Number(match[1]) * 60 + Number(match[2]) + delayMinutes) % 1440) + 1440) % 1440;
  return `${String(Math.floor(total / 60)).padStart(2, '0')}:${String(total % 60).padStart(2, '0')}`;
}

function formatDuration(minutes) {
  if (!Number.isFinite(minutes) || minutes <= 0) return null;
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;
  return `${hours}:${String(mins).padStart(2, '0')} hrs`;
}

function runningDaysToBits(days) {
  if (!Array.isArray(days) || days.length === 0) return null;
  const order = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return order
    .map((day) => (days.some((entry) => String(entry).startsWith(day)) ? '1' : '0'))
    .join('');
}

async function request(path, params = {}) {
  const url = new URL(path, env.irctcBaseUrl);
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') {
      url.searchParams.set(key, String(value));
    }
  }

  let response;
  try {
    response = await fetch(url, {
      headers: {
        'x-api-key': env.irctcKey,
        accept: 'application/json',
      },
      signal: AbortSignal.timeout(30_000),
    });
  } catch (error) {
    throw upstreamError(
      error?.name === 'TimeoutError'
        ? 'Railway provider timed out. Try again.'
        : 'Could not reach the railway provider.',
    );
  }

  const text = await response.text();
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    throw upstreamError('Railway provider returned an unreadable response.');
  }

  if (response.status === 401 || response.status === 403) {
    throw new ApiError(
      503,
      'provider_unavailable',
      'Railway provider rejected the configured API key.',
    );
  }
  if (response.status === 429) {
    throw new ApiError(
      429,
      'rate_limited',
      'Railway provider rate limit reached. Try again shortly.',
    );
  }
  if (response.status === 404) {
    throw notFound(body?.error ?? 'Not found.');
  }
  if (!response.ok || body?.success === false) {
    const message = String(body?.error ?? `Provider error (${response.status})`);
    if (/invalid train|not found|no data/i.test(message)) throw notFound(message);
    throw upstreamError(message);
  }

  return body;
}

async function data(path, params) {
  const body = await request(path, params);
  return body.data;
}

function normalizeSchedule(data) {
  const stations = Array.isArray(data?.stations) ? data.stations : [];
  const origin = stations[0] ?? {};
  const destination = stations[stations.length - 1] ?? {};
  const departureMin = number(origin.departureMin);
  const arrivalMin =
    number(destination.arrivalMin) + number(destination.arrivalDayOffset ?? destination.dayOffset) * 1440;

  return {
    train: {
      number: String(data?.trainNo ?? ''),
      name: String(data?.trainName ?? ''),
      type: data?.trainType ?? null,
      source: data?.originCode ?? origin.code ?? null,
      sourceName: origin.name ?? null,
      destination: data?.destinationCode ?? destination.code ?? null,
      destinationName: destination.name ?? null,
      departure: origin.departure ?? null,
      arrival: destination.arrival ?? null,
      duration: formatDuration(arrivalMin - departureMin),
      runningDays: runningDaysToBits(data?.runningDays),
      distanceKm: number(data?.totalDistance),
    },
    route: stations.map((station, index) => ({
      code: station.code ?? null,
      name: station.name ?? null,
      arrival: station.arrival ?? '--',
      departure: station.departure ?? '--',
      halt:
        number(station.haltMinutes) > 0
          ? `${number(station.haltMinutes)} min`
          : null,
      distanceKm: number(station.distanceKm),
      day: number(station.dayOffset, 0) + 1,
      platform: null,
      distanceFromSourceKm: number(station.distanceKm),
      isLast: index === stations.length - 1,
    })),
  };
}

function normalizeLive(data) {
  const rawStops = Array.isArray(data?.stops) ? data.stops : [];
  const stops = rawStops.map((stop) => {
    const delay = number(stop.delayMin);
    const scheduledArrival = stop.arrives ?? '--';
    const scheduledDeparture = stop.departs ?? '--';
    return {
      code: null,
      name: stop.stationName ?? null,
      nameHindi: null,
      type: 'stoppage',
      status:
        stop.status === 'passed' || stop.status === 'current'
          ? stop.status
          : 'upcoming',
      platform: null,
      distanceKm: number(stop.distanceKm),
      day: number(stop.day, 1),
      arrival: {
        scheduled: scheduledArrival,
        actual: minutesToClock(scheduledArrival, delay),
        delayMinutes: scheduledArrival === '--' ? 0 : delay,
      },
      departure: {
        scheduled: scheduledDeparture,
        actual: minutesToClock(scheduledDeparture, delay),
        delayMinutes: scheduledDeparture === '--' ? 0 : delay,
      },
      delayMinutes: delay,
    };
  });

  const currentIndex = stops.findIndex((stop) => stop.status === 'current');
  const passedStations = stops.filter((stop) => stop.status === 'passed').length;
  const remainingStations = stops.filter((stop) => stop.status === 'upcoming').length;
  const totalDistance = number(data?.totalDistanceKm);
  const locationStatus = String(data?.locationStatus ?? '').toLowerCase();

  let covered = currentIndex >= 0 ? stops[currentIndex].distanceKm : 0;
  if (!covered) {
    for (let index = Math.min(stops.length - 1, currentIndex); index >= 0; index -= 1) {
      if (stops[index].distanceKm > 0) {
        covered = stops[index].distanceKm;
        break;
      }
    }
  }

  const completed = locationStatus.includes('reached destination');
  const notStarted = locationStatus.includes('yet to start');
  const percent = completed
    ? 100
    : totalDistance > 0
      ? Math.min(100, Math.round((covered / totalDistance) * 1000) / 10)
      : 0;

  const currentLocation = data?.currentLocation ?? null;
  let statusNote = null;
  if (currentLocation) {
    if (notStarted) {
      statusNote = `Yet to start from ${currentLocation}`;
    } else if (completed) {
      statusNote = `Reached ${currentLocation}`;
    } else if (locationStatus.includes('departed')) {
      statusNote = `Departed from ${currentLocation}`;
    } else if (locationStatus.includes('arrived')) {
      statusNote = `Arrived at ${currentLocation}`;
    } else {
      statusNote = `${locationStatus.charAt(0).toUpperCase()}${locationStatus.slice(1)} ${currentLocation}`;
    }
  }

  const lastUpdated =
    data?.updatedAt ?? toIso(data?.lastUpdated);

  return {
    trainNo: String(data?.trainNumber ?? ''),
    trainName: String(data?.trainName ?? ''),
    trainNameHindi: null,
    journeyDate: null,
    statusNote: statusNote || null,
    lastUpdated,
    currentStationCode: null,
    currentStationName: currentLocation,
    delayMinutes: number(data?.currentDelayMin) || Math.max(0, ...stops.map((stop) => stop.delayMinutes)),
    totalDistanceKm: totalDistance,
    progress: {
      journeyStatus: completed
        ? 'completed'
        : notStarted
          ? 'not_started'
          : 'running',
      currentStationIndex: currentIndex,
      totalStations: stops.length,
      passedStations,
      remainingStations,
      currentDistanceKm: covered,
      distanceRemainingKm: Math.max(0, totalDistance - covered),
      percent,
    },
    stops,
    coaches: [],
  };
}

function normalizeBoard(body) {
  const trains = Array.isArray(body?.trains) ? body.trains : [];
  return {
    station: {
      code: body?.stationCode ?? null,
      name: body?.stationName ?? null,
      city: null,
    },
    windowHours: number(body?.hours, 2),
    updatedAt: new Date().toISOString(),
    trains: trains.map((train) => {
      const routeParts = String(train.route ?? '').split('-');
      const arrival = train.arrival ?? {};
      const departure = train.departure ?? {};
      return {
        trainNo: String(train.trainNo ?? ''),
        trainName: train.trainName ?? null,
        trainType: train.trainType ?? null,
        routeLabel: train.route ?? null,
        source: routeParts[0] || null,
        sourceName: null,
        destinationCode: routeParts[1] || null,
        destinationName: null,
        platform: train.platform?.number ? String(train.platform.number) : null,
        platformProvisional: Boolean(train.platform?.isProvisional),
        cancelled: false,
        startsHere: Boolean(arrival.isSource),
        endsHere: Boolean(departure.isDestination),
        arrival: {
          scheduled: arrival.scheduled ?? null,
          actual: arrival.actualOrEstimated ?? null,
          delayMinutes: number(arrival.delayMinutes),
        },
        departure: {
          scheduled: departure.scheduled ?? null,
          actual: departure.actualOrEstimated ?? null,
          delayMinutes: number(departure.delayMinutes),
        },
      };
    }),
  };
}

export async function searchTrains(query) {
  const trimmed = String(query ?? '').trim();
  if (/^\d{2,4}$/.test(trimmed)) {
    return [];
  }
  if (/^\d{5}$/.test(trimmed)) {
    const schedule = await data(`/api/v1/trains/${trimmed}`);
    return [normalizeSchedule(schedule).train];
  }

  const body = await request('/api/v1/trains/search/name', { name: trimmed });
  const trains = Array.isArray(body.data) ? body.data : [];
  return trains.map((train) => ({
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
    distanceKm: 0,
  }));
}

export async function searchStations(query) {
  const body = await data('/api/v1/trains/stations', { q: String(query ?? '').trim() });
  const stations = Array.isArray(body) ? body : [];
  return stations.map((station) => ({
    code: String(station.code ?? ''),
    name: String(station.name ?? ''),
    city: station.state ?? null,
  }));
}

export async function getTrain(numberParam) {
  const schedule = await data(`/api/v1/trains/${numberParam}`);
  return normalizeSchedule(schedule);
}

export async function getLive(numberParam, date) {
  const [day, month, year] = String(date).split('-');
  const body = await data(`/api/v1/live/${numberParam}`, {
    date: `${year}-${month}-${day}`,
  });
  return normalizeLive(body);
}

export async function getPnr(pnr) {
  const body = await data(`/api/v1/pnr/${pnr}`);
  const passengers = Array.isArray(body?.passengers) ? body.passengers : [];
  return {
    pnr: String(body?.pnr ?? pnr),
    train: {
      number: String(body?.trainNumber ?? ''),
      name: String(body?.trainName ?? ''),
    },
    journey: {
      dateOfJourney: body?.journeyDate ?? null,
      class: body?.class ?? null,
      quota: body?.quota ?? null,
      source: body?.from ? { code: body.from.code, name: body.from.code } : null,
      destination: body?.to ? { code: body.to.code, name: body.to.code } : null,
      boardingPoint: body?.from ? { code: body.from.code, name: body.from.code } : null,
      distance: null,
      arrivalDate: body?.to?.time ?? null,
    },
    chart: { status: body?.chartStatus ?? null },
    booking: {
      fare: body?.fare ?? null,
      ticketFare: null,
      bookingDate: null,
    },
    passengers: passengers.map((passenger) => ({
      serialNumber: `Passenger ${passenger.number}`,
      booking: {
        status: passenger.status ?? null,
        coach: passenger.coach ?? null,
        berthNo: passenger.seat ?? null,
        berthCode: passenger.berth ?? null,
        details: passenger.raw ?? null,
      },
      current: {
        status: passenger.status ?? null,
        coach: passenger.coach ?? null,
        berthNo: passenger.seat ?? null,
        berthCode: passenger.berth ?? null,
        details: passenger.raw ?? null,
      },
    })),
  };
}

export async function getStationBoard(code, hours) {
  const body = await request(`/api/v1/live/station/${code}`, { hours });
  return normalizeBoard(body);
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

import {
  DEMO_PNRS,
  DEMO_STATIONS,
  DEMO_TRAINS,
  POPULAR_TRAINS,
} from './data.js';
import { badRequest, notFound } from '../errors.js';

const MINUTE = 60 * 1000;

function minutesOf(value) {
  if (!value || value === '--' || value === 'SRC' || value === 'DST') return null;
  const match = /^(\d{1,2}):(\d{2})$/.exec(value);
  if (!match) return null;
  return Number(match[1]) * 60 + Number(match[2]);
}

function formatClock(totalMinutes) {
  const wrapped = ((totalMinutes % 1440) + 1440) % 1440;
  const hours = Math.floor(wrapped / 60);
  const minutes = wrapped % 60;
  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
}

function addMinutes(value, delta) {
  const base = minutesOf(value);
  if (base == null) return value;
  return formatClock(base + delta);
}

function haltLabel(arrival, departure) {
  const arr = minutesOf(arrival);
  const dep = minutesOf(departure);
  if (arr == null || dep == null) return null;
  const halt = ((dep - arr) % 1440 + 1440) % 1440;
  return halt > 0 ? `${halt} min` : null;
}

function stationFromRow(row, index, rows) {
  const [code, name, arrival, departure, distanceKm, day, platform] = row;
  return {
    code,
    name,
    arrival,
    departure,
    halt: haltLabel(arrival, departure),
    distanceKm,
    day,
    platform,
    distanceFromSourceKm: distanceKm,
    isLast: index === rows.length - 1,
  };
}

function trainProfile(train) {
  return {
    number: train.number,
    name: train.name,
    type: train.type,
    source: train.source,
    sourceName: train.sourceName,
    destination: train.dest,
    destinationName: train.destName,
    departure: train.departure,
    arrival: train.arrival,
    duration: train.duration,
    runningDays: train.runningDays,
    distanceKm: train.distanceKm,
  };
}

function routeOf(train) {
  return train.stops.map((row, index, rows) => stationFromRow(row, index, rows));
}

function requireTrain(number) {
  const train = DEMO_TRAINS.find((entry) => entry.number === String(number));
  if (!train) {
    throw notFound(
      `Demo mode has no data for train ${number}. Try 12951, 12301, 12627, 12002, 12841 or 12259.`,
    );
  }
  return train;
}

export function searchTrains(query) {
  const needle = String(query ?? '').trim().toLowerCase();
  if (needle.length < 2) return [];

  if (/^\d{2,5}$/.test(needle)) {
    return DEMO_TRAINS.filter((train) => train.number.startsWith(needle)).map(
      trainProfile,
    );
  }

  return DEMO_TRAINS.filter(
    (train) =>
      train.name.toLowerCase().includes(needle) ||
      train.sourceName.toLowerCase().includes(needle) ||
      train.destName.toLowerCase().includes(needle),
  ).map(trainProfile);
}

export function getTrain(number) {
  const train = requireTrain(number);
  return {
    train: trainProfile(train),
    route: routeOf(train),
  };
}

export function getPopularTrains() {
  return POPULAR_TRAINS.map((number) => trainProfile(requireTrain(number)));
}

export function getLiveStatus(number, journeyDate) {
  const train = requireTrain(number);
  const total = train.stops.length;
  const currentIndex = Math.min(
    Math.max(train.currentIndex, 0),
    total - 2,
  );
  const delay = train.delayMinutes;

  const stops = train.stops.map((row, index, rows) => {
    const station = stationFromRow(row, index, rows);
    const status =
      index < currentIndex
        ? 'passed'
        : index === currentIndex
          ? 'current'
          : 'upcoming';

    const arrivalScheduled = station.arrival;
    const departureScheduled = station.departure;
    const usesDelay = status !== 'upcoming';

    return {
      code: station.code,
      name: station.name,
      type: 'stoppage',
      status,
      platform: station.platform,
      distanceKm: station.distanceKm,
      day: station.day,
      arrival: {
        scheduled: arrivalScheduled,
        actual:
          usesDelay && arrivalScheduled !== '--'
            ? addMinutes(arrivalScheduled, delay)
            : arrivalScheduled,
        delayMinutes:
          usesDelay && arrivalScheduled !== '--' ? delay : 0,
      },
      departure: {
        scheduled: departureScheduled,
        actual:
          usesDelay && departureScheduled !== '--'
            ? addMinutes(departureScheduled, delay)
            : departureScheduled,
        delayMinutes:
          usesDelay && departureScheduled !== '--' ? delay : 0,
      },
    };
  });

  const current = stops[currentIndex];
  const covered = current.distanceKm;
  const percent = Math.min(
    99,
    Math.round((covered / train.distanceKm) * 1000) / 10,
  );

  return {
    trainNo: train.number,
    trainName: train.name,
    journeyDate: journeyDate ?? null,
    statusNote:
      currentIndex === 0
        ? `Departed from ${current.name}`
        : `Arrived at ${current.name}`,
    lastUpdated: new Date(Date.now() - 2 * MINUTE).toISOString(),
    currentStationCode: current.code,
    currentStationName: current.name,
    delayMinutes: delay,
    totalDistanceKm: train.distanceKm,
    progress: {
      journeyStatus: 'running',
      currentStationIndex: currentIndex,
      totalStations: total,
      passedStations: currentIndex,
      remainingStations: total - currentIndex - 1,
      currentDistanceKm: covered,
      distanceRemainingKm: Math.max(0, train.distanceKm - covered),
      percent,
    },
    stops,
    coaches: ['ENG', 'H1', 'A1', 'A2', 'B1', 'B2', 'B3', 'B4', 'B5', 'PC', 'S1', 'S2'],
  };
}

export function searchStations(query) {
  const needle = String(query ?? '').trim().toLowerCase();
  if (needle.length < 2) return [];
  return DEMO_STATIONS.filter(
    (station) =>
      station.code.toLowerCase().startsWith(needle) ||
      station.name.toLowerCase().includes(needle) ||
      station.city.toLowerCase().includes(needle),
  ).slice(0, 10);
}

export function getStationBoard(code, hours = 2) {
  const station = DEMO_STATIONS.find(
    (entry) => entry.code === String(code).toUpperCase(),
  );
  if (!station) {
    throw notFound(
      `Demo mode has no station ${code}. Try NDLS, HWH, BCT, SBC, MAS, BPL, SHM or SDAH.`,
    );
  }

  const trains = [];
  for (const train of DEMO_TRAINS) {
    const stop = train.stops.find((row) => row[0] === station.code);
    if (!stop) continue;
    const index = train.stops.indexOf(stop);
    const isOrigin = index === 0;
    const isDestination = index === train.stops.length - 1;
    const delay = index <= train.currentIndex ? train.delayMinutes : 0;
    const scheduledArrival = stop[2];
    const scheduledDeparture = stop[3];

    trains.push({
      trainNo: train.number,
      trainName: train.name,
      trainType: train.type,
      source: train.source,
      sourceName: train.sourceName,
      destinationCode: train.dest,
      destinationName: train.destName,
      routeLabel: `${train.source}-${train.dest}`,
      platform: stop[6],
      cancelled: false,
      arrival: {
        scheduled: scheduledArrival,
        actual:
          scheduledArrival !== '--'
            ? addMinutes(scheduledArrival, delay)
            : scheduledArrival,
        delayMinutes: scheduledArrival !== '--' ? delay : 0,
        delayed: delay > 0 && scheduledArrival !== '--',
      },
      departure: {
        scheduled: scheduledDeparture,
        actual:
          scheduledDeparture !== '--'
            ? addMinutes(scheduledDeparture, delay)
            : scheduledDeparture,
        delayMinutes: scheduledDeparture !== '--' ? delay : 0,
        delayed: delay > 0 && scheduledDeparture !== '--',
      },
      startsHere: isOrigin,
      endsHere: isDestination,
    });
  }

  return {
    station: { code: station.code, name: station.name, city: station.city },
    windowHours: hours,
    updatedAt: new Date().toISOString(),
    trains,
  };
}

export function getPnrStatus(pnr) {
  const digits = String(pnr ?? '').replace(/\D/g, '');
  if (digits.length !== 10) {
    throw badRequest('PNR number must be exactly 10 digits.');
  }

  const train = requireTrain(
    DEMO_TRAINS[Number(digits.slice(-1)) % DEMO_TRAINS.length].number,
  );
  const passengerCount = 2 + (Number(digits.slice(-2)) % 2);
  const coach = train.type === 'Shatabdi' ? 'C2' : 'B5';
  const coachClass = train.type === 'Shatabdi' ? 'CC' : '3A';
  const berths = ['LB', 'UB', 'SL', 'MB'];

  const passengers = Array.from({ length: passengerCount }, (_, index) => {
    const confirmed = index === 0 || Number(digits[index]) % 2 === 0;
    const berthNo = 12 + index * 7;
    const berthCode = berths[berthNo % berths.length];
    const bookingStatus = confirmed ? 'CNF' : 'RAC';
    return {
      serialNumber: `Passenger ${index + 1}`,
      booking: {
        status: bookingStatus,
        coach: confirmed ? coach : null,
        berthNo: confirmed ? berthNo : berthNo + 20,
        berthCode: confirmed ? berthCode : null,
        details: confirmed
          ? `CNF/${coach}/${berthNo}/${berthCode}`
          : `RAC/${berthNo + 20}`,
      },
      current: {
        status: 'CNF',
        coach,
        berthNo,
        berthCode,
        details: `CNF , ${coach} - ${berthNo} [${berthCode}]`,
      },
    };
  });

  const journeyDate = new Date();
  journeyDate.setDate(journeyDate.getDate() + 3);

  return {
    pnr: digits,
    train: { number: train.number, name: train.name },
    journey: {
      dateOfJourney: journeyDate.toISOString(),
      class: coachClass,
      quota: 'GN',
      source: { code: train.source, name: train.sourceName },
      destination: { code: train.dest, name: train.destName },
      boardingPoint: { code: train.source, name: train.sourceName },
      distance: train.distanceKm,
      arrivalDate: null,
    },
    chart: { status: 'Chart Prepared' },
    booking: {
      fare: 1845,
      ticketFare: 1795,
      bookingDate: new Date(Date.now() - 3 * 24 * 60 * MINUTE).toISOString(),
    },
    passengers,
    demoHint: `Demo mode. Any 10-digit PNR returns sample data — try ${DEMO_PNRS.join(' or ')}.`,
  };
}

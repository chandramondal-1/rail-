const MONTHS = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

function delayMinutes(value) {
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  const text = String(value ?? '').trim();
  if (!text || text === '--') return 0;
  const clock = /^(\d{1,2}):(\d{2})$/.exec(text);
  if (clock) return Number(clock[1]) * 60 + Number(clock[2]);
  const minutes = /^(-?\d+)\s*(?:min|m)?$/i.exec(text);
  if (minutes) return Number(minutes[1]);
  return 0;
}

function number(value, fallback = 0) {
  const parsed = Number.parseFloat(String(value ?? '').replace(/[^\d.-]/g, ''));
  return Number.isFinite(parsed) ? parsed : fallback;
}

function clock(value) {
  const text = String(value ?? '').trim();
  return text.length > 0 ? text : null;
}

function parseRailwayDate(value) {
  if (!value) return null;
  const text = String(value).trim();
  const iso = new Date(text);
  if (!Number.isNaN(iso.getTime()) && /T|\d{4}-\d{2}-\d{2}/.test(text)) {
    return iso.toISOString();
  }
  const match =
    /^(\d{1,2})-([A-Za-z]{3})-(\d{4})\s+(\d{1,2}):(\d{2})$/.exec(text);
  if (match) {
    const month = MONTHS.findIndex(
      (name) => name.toLowerCase() === match[2].toLowerCase(),
    );
    if (month >= 0) {
      const date = new Date(
        Number(match[3]),
        month,
        Number(match[1]),
        Number(match[4]),
        Number(match[5]),
      );
      return date.toISOString();
    }
  }
  return text;
}

export function normalizeTrainProfile(trainInfo) {
  return {
    number: String(trainInfo.train_no ?? ''),
    name: String(trainInfo.train_name ?? ''),
    type: trainInfo.type ?? null,
    source: trainInfo.from_stn_code ?? null,
    sourceName: trainInfo.from_stn_name ?? null,
    destination: trainInfo.to_stn_code ?? null,
    destinationName: trainInfo.to_stn_name ?? null,
    departure: clock(trainInfo.from_time),
    arrival: clock(trainInfo.to_time),
    duration: trainInfo.travel_time ?? null,
    runningDays: trainInfo.running_days ?? null,
    distanceKm: number(
      String(trainInfo.distance ?? '0').replace(/[^\d.]/g, ''),
      0,
    ),
  };
}

export function normalizeRoute(route) {
  const rows = Array.isArray(route) ? route : [];
  const last = rows[rows.length - 1];
  const totalDistance = last ? number(last.distance) : 0;
  return rows.map((station) => ({
    code: station.stnCode ?? null,
    name: station.stnName ?? null,
    arrival: clock(station.arrival),
    departure: clock(station.departure),
    halt: station.halt && station.halt !== '0 min' ? station.halt : null,
    distanceKm: number(station.distance),
    day: number(station.day, 1),
    platform: null,
    distanceFromSourceKm: number(station.distance),
    isLast: totalDistance > 0 && number(station.distance) >= totalDistance,
  }));
}

function normalizeArrival(entry, fallbackDelay = 0) {
  const source = entry ?? {};
  const delay = source.delay != null ? delayMinutes(source.delay) : fallbackDelay;
  return {
    scheduled: clock(source.scheduled),
    actual: clock(source.actual),
    delayMinutes: delay,
  };
}

export function normalizeLive(data) {
  const timeline = Array.isArray(data.timeline) ? data.timeline : [];
  const currentIndex = number(data.progress?.currentStationIndex, -1);
  const currentStop =
    timeline.find((stop) => stop.status === 'current') ??
    (currentIndex >= 0 ? timeline[currentIndex] : undefined);

  const stops = timeline.map((stop) => {
    const arrival = normalizeArrival(stop.arrival);
    const departure = normalizeArrival(stop.departure);
    const delay = Math.max(arrival.delayMinutes, departure.delayMinutes);
    return {
      code: stop.stationCode ?? null,
      name: stop.stationName ?? null,
      nameHindi: stop.stationNameHindi ?? null,
      type: stop.type === 'intermediate' ? 'intermediate' : 'stoppage',
      status:
        stop.status === 'passed' || stop.status === 'current'
          ? stop.status
          : 'upcoming',
      platform: stop.platform ? String(stop.platform) : null,
      distanceKm: number(stop.distanceKm),
      day: null,
      arrival,
      departure,
      delayMinutes: delay,
    };
  });

  const delayAtCurrent = currentStop
    ? Math.max(
        delayMinutes(currentStop.departure?.delay),
        delayMinutes(currentStop.arrival?.delay),
      )
    : 0;
  const observedDelay = stops.reduce(
    (max, stop) => (stop.status !== 'upcoming' ? Math.max(max, stop.delayMinutes) : max),
    0,
  );

  const progress = data.progress ?? {};
  const totalDistance = number(data.totalDistanceKm);
  const percent = number(progress.percent);
  const distanceCovered = number(progress.currentDistanceKm);

  return {
    trainNo: String(data.trainNo ?? ''),
    trainName: String(data.trainName ?? ''),
    trainNameHindi: data.trainNameHindi ?? null,
    journeyDate: data.date ?? null,
    statusNote: data.statusNote ?? null,
    lastUpdated: parseRailwayDate(data.lastUpdate),
    currentStationCode: data.currentStationCode ?? currentStop?.stationCode ?? null,
    currentStationName: currentStop?.stationName ?? null,
    delayMinutes: delayAtCurrent || observedDelay,
    totalDistanceKm: totalDistance,
    progress: {
      journeyStatus:
        progress.journeyStatus === 'not_started'
          ? 'not_started'
          : progress.journeyStatus === 'completed'
            ? 'completed'
            : 'running',
      currentStationIndex: number(progress.currentStationIndex, -1),
      totalStations: number(progress.totalStations, stops.length),
      passedStations: number(progress.passedStations),
      remainingStations: number(progress.remainingStations),
      currentDistanceKm: distanceCovered,
      distanceRemainingKm: number(progress.distanceRemainingKm),
      percent: Math.min(100, Math.max(0, percent)),
    },
    stops,
    coaches: (Array.isArray(data.coachPosition) ? data.coachPosition : []).map(
      (coach) => ({
        type: coach.type ?? '',
        number: coach.number ?? '',
        position: coach.position ?? '',
      }),
    ),
  };
}

export function normalizeStationBoard(data) {
  const trains = Array.isArray(data.trains) ? data.trains : [];
  return {
    station: {
      code: data.stationCode ?? null,
      name: data.stationName ?? null,
      city: null,
    },
    windowHours: number(data.windowHours, 2),
    updatedAt: new Date().toISOString(),
    trains: trains.map((train) => ({
      trainNo: String(train.trainNo ?? ''),
      trainName: train.trainName ?? null,
      trainType: train.trainType ?? null,
      source: train.source ?? null,
      sourceName: train.sourceName ?? null,
      destinationCode: train.dest ?? null,
      destinationName: train.destName ?? null,
      platform: train.platform ? String(train.platform) : null,
      cancelled: Boolean(train.cancelled),
      arrival: normalizeArrival(train.arrival),
      departure: normalizeArrival(train.departure),
      startsHere: Boolean(train.source && train.source === data.stationCode),
      endsHere: Boolean(train.dest && train.dest === data.stationCode),
    })),
  };
}

export function normalizePnr(data) {
  const passengers = Array.isArray(data.passengers) ? data.passengers : [];
  return {
    pnr: String(data.pnr ?? ''),
    train: {
      number: data.train?.number ?? '',
      name: data.train?.name ?? '',
    },
    journey: {
      dateOfJourney: data.journey?.dateOfJourney ?? null,
      class: data.journey?.class ?? null,
      quota: data.journey?.quota ?? null,
      source: data.journey?.source ?? null,
      destination: data.journey?.destination ?? null,
      boardingPoint: data.journey?.boardingPoint ?? null,
      distance: data.journey?.distance ?? null,
      arrivalDate: data.journey?.arrivalDate ?? null,
    },
    chart: { status: data.chart?.status ?? null },
    booking: {
      fare: data.booking?.fare ?? null,
      ticketFare: data.booking?.ticketFare ?? null,
      bookingDate: data.booking?.bookingDate ?? null,
    },
    passengers: passengers.map((passenger) => ({
      serialNumber: passenger.serialNumber ?? '',
      booking: {
        status: passenger.booking?.status ?? null,
        coach: passenger.booking?.coach ?? null,
        berthNo: passenger.booking?.berthNo ?? null,
        berthCode: passenger.booking?.berthCode ?? null,
        details: passenger.booking?.details ?? null,
      },
      current: {
        status: passenger.current?.status ?? null,
        coach: passenger.current?.coach ?? null,
        berthNo: passenger.current?.berthNo ?? null,
        berthCode: passenger.current?.berthCode ?? null,
        details: passenger.current?.details ?? null,
      },
    })),
  };
}

export { delayMinutes };

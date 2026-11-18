import 'package:railpulse/core/network/json_utils.dart';

class StopTime {
  const StopTime({
    this.scheduled,
    this.actual,
    this.delayMinutes = 0,
  });

  final String? scheduled;
  final String? actual;
  final int delayMinutes;

  factory StopTime.fromJson(Map<String, dynamic> json) => StopTime(
    scheduled: asString(json['scheduled']),
    actual: asString(json['actual']),
    delayMinutes: asInt(json['delayMinutes']),
  );
}

class LiveStop {
  const LiveStop({
    this.code,
    required this.name,
    this.nameHindi,
    required this.type,
    required this.status,
    this.platform,
    this.distanceKm = 0,
    this.day,
    required this.arrival,
    required this.departure,
    this.delayMinutes = 0,
  });

  final String? code;
  final String name;
  final String? nameHindi;
  final String type;
  final String status;
  final String? platform;
  final double distanceKm;
  final int? day;
  final StopTime arrival;
  final StopTime departure;
  final int delayMinutes;

  bool get isPassed => status == 'passed';
  bool get isCurrent => status == 'current';
  bool get isUpcoming => status == 'upcoming';

  factory LiveStop.fromJson(Map<String, dynamic> json) => LiveStop(
    code: asString(json['code']),
    name: asString(json['name']) ?? '',
    nameHindi: asString(json['nameHindi']),
    type: asString(json['type']) ?? 'stoppage',
    status: asString(json['status']) ?? 'upcoming',
    platform: asString(json['platform']),
    distanceKm: asDouble(json['distanceKm']),
    day: json['day'] == null ? null : asInt(json['day']),
    arrival: StopTime.fromJson(asMap(json['arrival'])),
    departure: StopTime.fromJson(asMap(json['departure'])),
    delayMinutes: asInt(json['delayMinutes']),
  );
}

class JourneyProgress {
  const JourneyProgress({
    required this.journeyStatus,
    required this.currentStationIndex,
    required this.totalStations,
    required this.passedStations,
    required this.remainingStations,
    required this.currentDistanceKm,
    required this.distanceRemainingKm,
    required this.percent,
  });

  final String journeyStatus;
  final int currentStationIndex;
  final int totalStations;
  final int passedStations;
  final int remainingStations;
  final double currentDistanceKm;
  final double distanceRemainingKm;
  final double percent;

  bool get isCompleted => journeyStatus == 'completed';
  bool get notStarted => journeyStatus == 'not_started';

  factory JourneyProgress.fromJson(Map<String, dynamic> json) =>
      JourneyProgress(
        journeyStatus: asString(json['journeyStatus']) ?? 'running',
        currentStationIndex: asInt(json['currentStationIndex'], -1),
        totalStations: asInt(json['totalStations']),
        passedStations: asInt(json['passedStations']),
        remainingStations: asInt(json['remainingStations']),
        currentDistanceKm: asDouble(json['currentDistanceKm']),
        distanceRemainingKm: asDouble(json['distanceRemainingKm']),
        percent: asDouble(json['percent']),
      );
}

class LiveStatus {
  const LiveStatus({
    required this.trainNo,
    required this.trainName,
    this.journeyDate,
    this.statusNote,
    this.lastUpdated,
    this.currentStationCode,
    this.currentStationName,
    this.delayMinutes = 0,
    this.totalDistanceKm = 0,
    required this.progress,
    required this.stops,
    required this.coaches,
  });

  final String trainNo;
  final String trainName;
  final String? journeyDate;
  final String? statusNote;
  final String? lastUpdated;
  final String? currentStationCode;
  final String? currentStationName;
  final int delayMinutes;
  final double totalDistanceKm;
  final JourneyProgress progress;
  final List<LiveStop> stops;
  final List<String> coaches;

  LiveStop? get currentStop {
    for (final stop in stops) {
      if (stop.isCurrent) return stop;
    }
    return null;
  }

  LiveStop? get nextStop {
    for (final stop in stops) {
      if (stop.isUpcoming) return stop;
    }
    return null;
  }

  LiveStop? get lastPassedStop {
    for (var index = stops.length - 1; index >= 0; index -= 1) {
      if (stops[index].isPassed) return stops[index];
    }
    return null;
  }

  factory LiveStatus.fromJson(Map<String, dynamic> json) {
    final stops = asMapList(json['stops'])
        .map(LiveStop.fromJson)
        .toList(growable: false);
    final coaches = <String>[];
    if (json['coaches'] is List) {
      for (final coach in json['coaches'] as List) {
        if (coach is String) {
          coaches.add(coach);
        } else if (coach is Map) {
          final map = asMap(coach);
          final label = asString(map['number']) ?? asString(map['type']);
          if (label != null) coaches.add(label);
        }
      }
    }

    return LiveStatus(
      trainNo: asString(json['trainNo']) ?? '',
      trainName: asString(json['trainName']) ?? '',
      journeyDate: asString(json['journeyDate']),
      statusNote: asString(json['statusNote']),
      lastUpdated: asString(json['lastUpdated']),
      currentStationCode: asString(json['currentStationCode']),
      currentStationName: asString(json['currentStationName']),
      delayMinutes: asInt(json['delayMinutes']),
      totalDistanceKm: asDouble(json['totalDistanceKm']),
      progress: JourneyProgress.fromJson(asMap(json['progress'])),
      stops: stops,
      coaches: coaches,
    );
  }
}

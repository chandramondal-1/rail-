import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/shared/models/station_summary.dart';

class BoardTime {
  const BoardTime({
    this.scheduled,
    this.actual,
    this.delayMinutes = 0,
  });

  final String? scheduled;
  final String? actual;
  final int delayMinutes;

  bool get isDelayed => delayMinutes > 0;

  factory BoardTime.fromJson(Map<String, dynamic> json) => BoardTime(
    scheduled: asString(json['scheduled']),
    actual: asString(json['actual']),
    delayMinutes: asInt(json['delayMinutes']),
  );
}

class BoardTrain {
  const BoardTrain({
    required this.trainNo,
    required this.trainName,
    this.trainType,
    this.routeLabel,
    this.source,
    this.sourceName,
    this.destinationCode,
    this.destinationName,
    this.platform,
    this.platformProvisional = false,
    this.cancelled = false,
    this.startsHere = false,
    this.endsHere = false,
    required this.arrival,
    required this.departure,
  });

  final String trainNo;
  final String trainName;
  final String? trainType;
  final String? routeLabel;
  final String? source;
  final String? sourceName;
  final String? destinationCode;
  final String? destinationName;
  final String? platform;
  final bool platformProvisional;
  final bool cancelled;
  final bool startsHere;
  final bool endsHere;
  final BoardTime arrival;
  final BoardTime departure;

  String get fromLabel => sourceName ?? source ?? '';
  String get toLabel => destinationName ?? destinationCode ?? '';

  factory BoardTrain.fromJson(Map<String, dynamic> json) => BoardTrain(
    trainNo: asString(json['trainNo']) ?? '',
    trainName: asString(json['trainName']) ?? '',
    trainType: asString(json['trainType']),
    routeLabel: asString(json['routeLabel']),
    source: asString(json['source']),
    sourceName: asString(json['sourceName']),
    destinationCode: asString(json['destinationCode']),
    destinationName: asString(json['destinationName']),
    platform: asString(json['platform']),
    platformProvisional: asBool(json['platformProvisional']),
    cancelled: asBool(json['cancelled']),
    startsHere: asBool(json['startsHere']),
    endsHere: asBool(json['endsHere']),
    arrival: BoardTime.fromJson(asMap(json['arrival'])),
    departure: BoardTime.fromJson(asMap(json['departure'])),
  );
}

class StationBoard {
  const StationBoard({
    required this.station,
    required this.windowHours,
    this.updatedAt,
    required this.trains,
  });

  final StationSummary station;
  final int windowHours;
  final DateTime? updatedAt;
  final List<BoardTrain> trains;

  factory StationBoard.fromJson(Map<String, dynamic> json) {
    return StationBoard(
      station: StationSummary.fromJson(asMap(json['station'])),
      windowHours: asInt(json['windowHours'], 2),
      updatedAt: DateTime.tryParse(asString(json['updatedAt']) ?? ''),
      trains: asMapList(json['trains'])
          .map(BoardTrain.fromJson)
          .toList(growable: false),
    );
  }
}

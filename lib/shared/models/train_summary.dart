import 'package:railpulse/core/network/json_utils.dart';

class TrainSummary {
  const TrainSummary({
    required this.number,
    required this.name,
    this.type,
    this.source,
    this.sourceName,
    this.destination,
    this.destinationName,
    this.departure,
    this.arrival,
    this.duration,
    this.runningDays,
    this.distanceKm = 0,
  });

  final String number;
  final String name;
  final String? type;
  final String? source;
  final String? sourceName;
  final String? destination;
  final String? destinationName;
  final String? departure;
  final String? arrival;
  final String? duration;
  final String? runningDays;
  final double distanceKm;

  factory TrainSummary.fromJson(Map<String, dynamic> json) {
    return TrainSummary(
      number: asString(json['number']) ?? asString(json['trainNo']) ?? '',
      name: asString(json['name']) ?? asString(json['trainName']) ?? '',
      type: asString(json['type']) ?? asString(json['trainType']),
      source: asString(json['source']) ?? asString(json['from']),
      sourceName: asString(json['sourceName']),
      destination:
          asString(json['destination']) ??
          asString(json['destinationCode']) ??
          asString(json['to']),
      destinationName: asString(json['destinationName']),
      departure: asString(json['departure']),
      arrival: asString(json['arrival']),
      duration: asString(json['duration']),
      runningDays: asString(json['runningDays']),
      distanceKm: asDouble(json['distanceKm']),
    );
  }

  Map<String, dynamic> toJson() => {
    'number': number,
    'name': name,
    if (type != null) 'type': type,
    if (source != null) 'source': source,
    if (sourceName != null) 'sourceName': sourceName,
    if (destination != null) 'destination': destination,
    if (destinationName != null) 'destinationName': destinationName,
    if (departure != null) 'departure': departure,
    if (arrival != null) 'arrival': arrival,
    if (duration != null) 'duration': duration,
    if (runningDays != null) 'runningDays': runningDays,
    'distanceKm': distanceKm,
  };

  String get routeLabel {
    final from = sourceName ?? source;
    final to = destinationName ?? destination;
    if (from == null && to == null) return '';
    return '${from ?? ''} → ${to ?? ''}';
  }
}

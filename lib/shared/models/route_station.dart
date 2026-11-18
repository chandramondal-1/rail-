import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/shared/models/train_summary.dart';

class RouteStation {
  const RouteStation({
    required this.code,
    required this.name,
    required this.arrival,
    required this.departure,
    required this.distanceKm,
    required this.day,
    this.halt,
    this.platform,
    this.isLast = false,
  });

  final String? code;
  final String name;
  final String? arrival;
  final String? departure;
  final String? halt;
  final double distanceKm;
  final int day;
  final String? platform;
  final bool isLast;

  factory RouteStation.fromJson(Map<String, dynamic> json) {
    return RouteStation(
      code: asString(json['code']),
      name: asString(json['name']) ?? '',
      arrival: asString(json['arrival']),
      departure: asString(json['departure']),
      halt: asString(json['halt']),
      distanceKm: asDouble(json['distanceKm']),
      day: asInt(json['day'], 1),
      platform: asString(json['platform']),
      isLast: asBool(json['isLast']),
    );
  }
}

class TrainDetail {
  const TrainDetail({required this.train, required this.route});

  final TrainSummary train;
  final List<RouteStation> route;
}

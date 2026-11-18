import 'package:railpulse/core/network/json_utils.dart';

class StationSummary {
  const StationSummary({
    required this.code,
    required this.name,
    this.city,
  });

  final String code;
  final String name;
  final String? city;

  factory StationSummary.fromJson(Map<String, dynamic> json) {
    return StationSummary(
      code: asString(json['code']) ?? '',
      name: asString(json['name']) ?? '',
      city: asString(json['city']),
    );
  }

  String get label => city == null || city!.isEmpty ? name : '$name · $city';
}

import 'package:railpulse/core/network/json_utils.dart';

class PnrLocation {
  const PnrLocation({required this.code, this.name});

  final String code;
  final String? name;

  factory PnrLocation.fromJson(Map<String, dynamic> json) => PnrLocation(
    code: asString(json['code']) ?? '',
    name: asString(json['name']),
  );

  String get label {
    if (name == null || name == code) return code;
    return '$name ($code)';
  }
}

class PnrPassengerStatus {
  const PnrPassengerStatus({
    this.status,
    this.coach,
    this.berthNo,
    this.berthCode,
    this.details,
  });

  final String? status;
  final String? coach;
  final dynamic berthNo;
  final String? berthCode;
  final String? details;

  factory PnrPassengerStatus.fromJson(Map<String, dynamic> json) =>
      PnrPassengerStatus(
        status: asString(json['status']),
        coach: asString(json['coach']),
        berthNo: json['berthNo'],
        berthCode: asString(json['berthCode']),
        details: asString(json['details']),
      );
}

class PnrPassenger {
  const PnrPassenger({
    required this.serialNumber,
    required this.booking,
    required this.current,
  });

  final String serialNumber;
  final PnrPassengerStatus booking;
  final PnrPassengerStatus current;

  factory PnrPassenger.fromJson(Map<String, dynamic> json) => PnrPassenger(
    serialNumber: asString(json['serialNumber']) ?? 'Passenger',
    booking: PnrPassengerStatus.fromJson(asMap(json['booking'])),
    current: PnrPassengerStatus.fromJson(asMap(json['current'])),
  );
}

class PnrJourney {
  const PnrJourney({
    this.dateOfJourney,
    this.classCode,
    this.quota,
    this.source,
    this.destination,
    this.boardingPoint,
    this.distance,
    this.arrivalDate,
  });

  final String? dateOfJourney;
  final String? classCode;
  final String? quota;
  final PnrLocation? source;
  final PnrLocation? destination;
  final PnrLocation? boardingPoint;
  final dynamic distance;
  final String? arrivalDate;

  factory PnrJourney.fromJson(Map<String, dynamic> json) => PnrJourney(
    dateOfJourney: asString(json['dateOfJourney']),
    classCode: asString(json['class']),
    quota: asString(json['quota']),
    source: json['source'] == null
        ? null
        : PnrLocation.fromJson(asMap(json['source'])),
    destination: json['destination'] == null
        ? null
        : PnrLocation.fromJson(asMap(json['destination'])),
    boardingPoint: json['boardingPoint'] == null
        ? null
        : PnrLocation.fromJson(asMap(json['boardingPoint'])),
    distance: json['distance'],
    arrivalDate: asString(json['arrivalDate']),
  );
}

class PnrResult {
  const PnrResult({
    required this.pnr,
    required this.trainNumber,
    required this.trainName,
    required this.journey,
    this.chartStatus,
    this.fare,
    required this.passengers,
  });

  final String pnr;
  final String trainNumber;
  final String trainName;
  final PnrJourney journey;
  final String? chartStatus;
  final num? fare;
  final List<PnrPassenger> passengers;

  factory PnrResult.fromJson(Map<String, dynamic> json) {
    final train = asMap(json['train']);
    final booking = asMap(json['booking']);
    final chart = asMap(json['chart']);
    return PnrResult(
      pnr: asString(json['pnr']) ?? '',
      trainNumber: asString(train['number']) ?? '',
      trainName: asString(train['name']) ?? '',
      journey: PnrJourney.fromJson(asMap(json['journey'])),
      chartStatus: asString(chart['status']),
      fare: booking['fare'] is num ? booking['fare'] as num : null,
      passengers: asMapList(json['passengers'])
          .map(PnrPassenger.fromJson)
          .toList(growable: false),
    );
  }
}

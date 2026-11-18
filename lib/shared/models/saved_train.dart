import 'package:railpulse/shared/models/train_summary.dart';

class SavedTrain {
  const SavedTrain({
    required this.number,
    required this.name,
    this.source,
    this.destination,
  });

  final String number;
  final String name;
  final String? source;
  final String? destination;

  factory SavedTrain.fromTrain(TrainSummary train) => SavedTrain(
    number: train.number,
    name: train.name,
    source: train.sourceName ?? train.source,
    destination: train.destinationName ?? train.destination,
  );

  factory SavedTrain.fromJson(Map<String, dynamic> json) => SavedTrain(
    number: (json['number'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    source: json['source'] as String?,
    destination: json['destination'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'name': name,
    if (source != null) 'source': source,
    if (destination != null) 'destination': destination,
  };

  String get routeLabel {
    if (source == null && destination == null) return '';
    return '${source ?? ''} → ${destination ?? ''}';
  }
}

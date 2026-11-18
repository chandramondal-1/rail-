import 'package:flutter_test/flutter_test.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/core/utils/formatters.dart';
import 'package:railpulse/features/pnr/models/pnr_result.dart';
import 'package:railpulse/shared/models/saved_train.dart';
import 'package:railpulse/shared/models/train_summary.dart';

void main() {
  group('json utils', () {
    test('parses numbers, booleans and maps defensively', () {
      expect(asDouble('1,384 km'), 1384.0);
      expect(asDouble(null, 7), 7);
      expect(asInt('42'), 42);
      expect(asBool('yes'), isTrue);
      expect(asMap(null), isEmpty);
      expect(asMapList([{'a': 1}, 'nope']), hasLength(1));
    });
  });

  group('formatters', () {
    test('formats API dates as DD-MM-YYYY', () {
      expect(formatApiDate(DateTime(2026, 11, 8)), '08-11-2026');
    });

    test('parses ISO timestamps and rejects junk', () {
      expect(parseTimestamp('2026-11-18T10:28:28.990Z'), isNotNull);
      expect(parseTimestamp('not a date'), isNull);
      expect(parseTimestamp(null), isNull);
    });

    test('normalises display times', () {
      expect(displayTime('09:45'), '09:45');
      expect(displayTime('--'), isNull);
      expect(displayTime('  '), isNull);
    });

    test('builds running day labels', () {
      expect(isDailyService('1111111'), isTrue);
      expect(runningDayLabels('1010101'), ['Mon', 'Wed', 'Fri', 'Sun']);
    });
  });

  group('TrainSummary', () {
    test('reads mixed provider field names', () {
      final train = TrainSummary.fromJson({
        'trainNo': '12951',
        'trainName': 'NDLS TEJAS RAJ',
        'trainType': 'RAJDHANI',
        'from': 'MMCT',
        'to': 'NDLS',
        'distanceKm': '1380',
      });

      expect(train.number, '12951');
      expect(train.name, 'NDLS TEJAS RAJ');
      expect(train.source, 'MMCT');
      expect(train.destination, 'NDLS');
      expect(train.routeLabel, 'MMCT → NDLS');
      expect(train.distanceKm, 1380);
    });
  });

  group('SavedTrain', () {
    test('round-trips through JSON', () {
      final saved = SavedTrain.fromTrain(
        const TrainSummary(
          number: '12301',
          name: 'HOWRAH RAJDHANI',
          sourceName: 'HOWRAH JN',
          destinationName: 'NEW DELHI',
        ),
      );

      final decoded = SavedTrain.fromJson(saved.toJson());
      expect(decoded.number, '12301');
      expect(decoded.name, 'HOWRAH RAJDHANI');
      expect(decoded.routeLabel, 'HOWRAH JN → NEW DELHI');
    });
  });

  group('PnrResult', () {
    test('maps the normalised proxy payload', () {
      final result = PnrResult.fromJson({
        'pnr': '2265248473',
        'train': {'number': '15726', 'name': 'ANVT NJP EXP'},
        'journey': {
          'dateOfJourney': 'Nov 23, 2026 10:05:00 AM',
          'class': 'SL',
          'quota': 'GN',
          'source': {'code': 'MFP', 'name': 'MUZAFFARPUR JN'},
          'destination': {'code': 'NJP', 'name': 'NEW JALPAIGURI'},
        },
        'chart': {'status': 'Chart not prepared'},
        'booking': {'fare': 640},
        'passengers': [
          {
            'serialNumber': 'Passenger 1',
            'booking': {'status': 'CNF', 'coach': 'S4', 'berthNo': 32},
            'current': {'status': 'CNF', 'coach': 'S4', 'berthNo': 32},
          },
        ],
      });

      expect(result.trainNumber, '15726');
      expect(result.journey.classCode, 'SL');
      expect(result.journey.source?.label, 'MUZAFFARPUR JN (MFP)');
      expect(result.chartStatus, 'Chart not prepared');
      expect(result.fare, 640);
      expect(result.passengers.single.current.coach, 'S4');
    });
  });
}

import 'package:intl/intl.dart';

String formatApiDate(DateTime date) =>
    '${_two(date.day)}-${_two(date.month)}-${date.year}';

String formatFriendlyDate(DateTime date) => DateFormat('EEE, d MMM').format(date);

String formatClock(DateTime date) => DateFormat('HH:mm').format(date);

String formatDateTime(DateTime date) => DateFormat('d MMM, HH:mm').format(date);

String _two(int value) => value.toString().padLeft(2, '0');

DateTime? parseTimestamp(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  return DateTime.tryParse(raw);
}

String? displayTime(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == '--' || trimmed == 'null') return null;
  return trimmed;
}

String distanceLabel(double km) {
  if (km <= 0) return '0 km';
  if (km >= 1000) return '${(km / 1000).toStringAsFixed(km % 1000 == 0 ? 0 : 1)}k km';
  return '${km.round()} km';
}

bool isDailyService(String? runningDays) =>
    runningDays == '1111111' || runningDays == null;

List<String> runningDayLabels(String? runningDays) {
  if (runningDays == null || runningDays.length < 7) return const [];
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final result = <String>[];
  for (var index = 0; index < 7; index += 1) {
    if (runningDays[index] == '1') result.add(labels[index]);
  }
  return result;
}

import 'package:flutter/foundation.dart';

/// Build-time configuration.
///
/// Override the API server for a physical device:
///   flutter run --dart-define=RAILPULSE_API_BASE_URL=http://192.168.1.10:8787
class AppConfig {
  const AppConfig._();

  static const String _override = String.fromEnvironment(
    'RAILPULSE_API_BASE_URL',
  );

  static const String appVersion = '1.0.0';

  static String get apiBaseUrl {
    if (_override.trim().isNotEmpty) {
      return _override.trim().replaceAll(RegExp(r'/+$'), '');
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator reaches the host machine through 10.0.2.2.
      return 'http://10.0.2.2:8787';
    }
    return 'http://localhost:8787';
  }

  static bool get isDebug => kDebugMode;
}

import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/app.dart';
import 'package:railpulse/core/config/app_config.dart';
import 'package:railpulse/core/storage/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await AppPreferences.load();
  runApp(
    RailPulseApp(
      preferences: preferences,
      apiBaseUrl: AppConfig.apiBaseUrl,
    ),
  );
}

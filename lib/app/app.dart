import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/app_shell.dart';
import 'package:railpulse/app/theme/app_theme.dart';
import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/core/storage/app_preferences.dart';
import 'package:railpulse/l10n/app_localizations.dart';

class RailPulseApp extends StatefulWidget {
  const RailPulseApp({
    super.key,
    required this.preferences,
    required this.apiBaseUrl,
  });

  final AppPreferences preferences;
  final String apiBaseUrl;

  @override
  State<RailPulseApp> createState() => _RailPulseAppState();
}

class _RailPulseAppState extends State<RailPulseApp> {
  late final AppState _state = AppState(widget.preferences);
  late final AppServices _services = AppServices(
    ApiClient(baseUrl: _state.apiBaseUrl ?? widget.apiBaseUrl),
  );

  @override
  void initState() {
    super.initState();
    _state.addListener(_syncBaseUrl);
  }

  void _syncBaseUrl() {
    _services.client.updateBaseUrl(_state.apiBaseUrl ?? widget.apiBaseUrl);
  }

  @override
  void dispose() {
    _state.removeListener(_syncBaseUrl);
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: _state),
        Provider<AppServices>.value(value: _services),
      ],
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'RailPulse',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}

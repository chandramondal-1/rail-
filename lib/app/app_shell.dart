import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/features/favourites/favourites_screen.dart';
import 'package:railpulse/features/home/home_screen.dart';
import 'package:railpulse/features/live_status/live_tab_screen.dart';
import 'package:railpulse/features/pnr/pnr_screen.dart';
import 'package:railpulse/features/settings/settings_screen.dart';
import 'package:railpulse/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenTab: _select),
          const LiveTabScreen(),
          const PnrScreen(),
          const FavouritesScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: palette.border)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.radar_outlined),
              selectedIcon: const Icon(Icons.radar_rounded),
              label: l10n.navLive,
            ),
            NavigationDestination(
              icon: const Icon(Icons.confirmation_number_outlined),
              selectedIcon: const Icon(Icons.confirmation_number_rounded),
              label: l10n.navPnr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.star_outline_rounded),
              selectedIcon: const Icon(Icons.star_rounded),
              label: l10n.navFavourites,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}

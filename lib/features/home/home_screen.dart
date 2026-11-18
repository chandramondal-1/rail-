import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_routes.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/features/settings/data/health_service.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/saved_train.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/app_snackbar.dart';
import 'package:railpulse/shared/widgets/pulse_dot.dart';
import 'package:railpulse/shared/widgets/rail_illustration.dart';
import 'package:railpulse/shared/widgets/reveal.dart';
import 'package:railpulse/shared/widgets/section_header.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';
import 'package:railpulse/shared/widgets/train_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TrainSummary> _popular = const [];
  ProviderHealth? _health;
  Object? _popularError;
  bool _loadingPopular = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final services = context.read<AppServices>();
    setState(() {
      _loadingPopular = true;
      _popularError = null;
    });

    final healthFuture = services.health.check().then<ProviderHealth?>(
      (value) => value,
      onError: (_) => null,
    );

    try {
      final popular = await services.trains.popular();
      final health = await healthFuture;
      if (!mounted) return;
      setState(() {
        _popular = popular.data;
        _health = health;
        _loadingPopular = false;
      });
    } catch (error) {
      final health = await healthFuture;
      if (!mounted) return;
      setState(() {
        _popularError = error;
        _health = health;
        _loadingPopular = false;
      });
    }
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final state = context.watch<AppState>();

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _load,
        color: palette.accent,
        backgroundColor: palette.card,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Row(
              children: [
                const RailPulseMark(size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_health != null)
                  StatusPill(
                    label: _health!.isDemo ? l10n.demoMode : l10n.liveData,
                    background: _health!.isDemo
                        ? palette.warningSoft
                        : palette.accentSoft,
                    foreground: _health!.isDemo
                        ? palette.warning
                        : palette.success,
                    icon: _health!.isDemo
                        ? Icons.science_outlined
                        : Icons.sensors_rounded,
                    dense: true,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _HeroSearch(
              greeting: _greeting(l10n),
              onTap: () => openTrainSearch(context),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.quickAccess),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.62,
              children: [
                _QuickTile(
                  icon: Icons.radar_rounded,
                  title: l10n.liveTrainStatus,
                  subtitle: l10n.liveTrainStatusSubtitle,
                  onTap: () => widget.onOpenTab(1),
                  accent: true,
                ),
                _QuickTile(
                  icon: Icons.route_rounded,
                  title: l10n.trainSchedule,
                  subtitle: l10n.trainScheduleSubtitle,
                  onTap: () => openTrainSearch(context, openRoute: true),
                ),
                _QuickTile(
                  icon: Icons.confirmation_number_outlined,
                  title: l10n.pnrStatus,
                  subtitle: l10n.pnrStatusSubtitle,
                  onTap: () => widget.onOpenTab(2),
                ),
                _QuickTile(
                  icon: Icons.departure_board_outlined,
                  title: l10n.stationStatus,
                  subtitle: l10n.stationStatusSubtitle,
                  onTap: () => openStationBoard(context),
                ),
              ],
            ),
            if (state.recents.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: l10n.recentSearches,
                actionLabel: l10n.clear,
                onAction: () async {
                  await context.read<AppState>().clearRecents();
                  if (!context.mounted) return;
                  AppSnackbar.show(context, l10n.recentsCleared);
                },
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final recent in state.recents)
                    _RecentChip(
                      train: recent,
                      onTap: () {
                        final train = TrainSummary(
                          number: recent.number,
                          name: recent.name,
                          source: recent.source,
                          destination: recent.destination,
                        );
                        context.read<AppState>().addRecent(train);
                        openTrain(context, train);
                      },
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SectionHeader(
              title: l10n.popularServices,
              actionLabel: l10n.viewAll,
              onAction: () => openTrainSearch(context),
            ),
            if (_loadingPopular)
              const SkeletonList(items: 3)
            else if (_popularError != null)
              AppCard(
                showShadow: false,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: AppErrorView(
                  error: _popularError!,
                  onRetry: _load,
                  compact: true,
                  action:
                      _popularError is ApiException &&
                          (_popularError as ApiException).isNetworkError
                      ? TextButton(
                          onPressed: () => widget.onOpenTab(4),
                          child: Text(l10n.apiServer),
                        )
                      : null,
                ),
              )
            else if (_popular.isEmpty)
              AppCard(
                showShadow: false,
                child: Text(
                  l10n.noData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              )
            else
              for (var index = 0; index < _popular.length; index += 1) ...[
                Reveal(
                  index: index,
                  child: TrainListTile(
                    train: _popular[index],
                    onTap: () => openTrain(context, _popular[index]),
                  ),
                ),
                if (index != _popular.length - 1) const SizedBox(height: 10),
              ],
            const SizedBox(height: 22),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: palette.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l10n.offlineNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSearch extends StatelessWidget {
  const _HeroSearch({required this.greeting, required this.onTap});

  final String greeting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.isDark
              ? [const Color(0xFF1B2B45), const Color(0xFF111A2C)]
              : [const Color(0xFF101828), const Color(0xFF1D2E4A)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -12,
              child: Icon(
                Icons.train_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.045),
              ),
            ),
            Positioned(
              right: 26,
              bottom: 18,
              child: Opacity(
                opacity: 0.22,
                child: RailwayIllustration(width: 150),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PulseDot(size: 7, color: palette.accent),
                      const SizedBox(width: 2),
                      Text(
                        greeting.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeTitle,
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      l10n.homeSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.66),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: Color(0xFF101828),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.searchHint,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF667085),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: palette.accentSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.searchAction,
                                style: textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF15803D),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent ? palette.accentSoft : palette.surfaceAlt,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 18,
              color: accent ? palette.success : palette.textSecondary,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  const _RecentChip({required this.train, required this.onTap});

  final SavedTrain train;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: palette.surfaceAlt,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 14,
                color: palette.textMuted,
              ),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 190),
                child: Text(
                  '${train.number} · ${train.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

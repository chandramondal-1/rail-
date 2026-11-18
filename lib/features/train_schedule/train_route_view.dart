import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/utils/formatters.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/route_station.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';
import 'package:railpulse/shared/widgets/mini_route.dart';
import 'package:railpulse/shared/widgets/section_header.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/stat_block.dart';

class TrainRouteView extends StatefulWidget {
  const TrainRouteView({super.key, required this.train});

  final TrainSummary train;

  @override
  State<TrainRouteView> createState() => _TrainRouteViewState();
}

class _TrainRouteViewState extends State<TrainRouteView> {
  TrainDetail? _detail;
  Object? _error;
  bool _loading = true;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant TrainRouteView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.train.number != widget.train.number) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await context
          .read<AppServices>()
          .trains
          .detail(widget.train.number);
      if (!mounted) return;
      setState(() {
        _detail = result.data;
        _isDemo = result.isDemo;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            SkeletonBox(width: double.infinity, height: 132, radius: 20),
            SizedBox(height: 18),
            SkeletonList(items: 6),
          ],
        ),
      );
    }

    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        color: palette.accent,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              showShadow: false,
              child: AppErrorView(error: _error!, onRetry: _load),
            ),
          ],
        ),
      );
    }

    final detail = _detail!;
    final train = detail.train;
    final route = detail.route;

    return RefreshIndicator(
      onRefresh: _load,
      color: palette.accent,
      backgroundColor: palette.card,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          DemoBanner(isDemo: _isDemo, margin: const EdgeInsets.only(bottom: 14)),
          AppCard(
            showShadow: false,
            child: Column(
              children: [
                MiniRoute(
                  fromLabel: train.sourceName ?? train.source ?? '—',
                  toLabel:
                      train.destinationName ?? train.destination ?? '—',
                  fromCode: train.source,
                  toCode: train.destination,
                  fromTime: displayTime(train.departure),
                  toTime: displayTime(train.arrival),
                ),
                const SizedBox(height: 16),
                Divider(color: palette.border, height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: StatBlock(
                        label: l10n.duration,
                        value: train.duration ?? '—',
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                    Expanded(
                      child: StatBlock(
                        label: l10n.distance,
                        value: train.distanceKm > 0
                            ? l10n.km(train.distanceKm.round().toString())
                            : '—',
                        icon: Icons.straighten_rounded,
                      ),
                    ),
                    Expanded(
                      child: StatBlock(
                        label: l10n.runsOn,
                        value: isDailyService(train.runningDays)
                            ? l10n.runsDaily
                            : runningDayLabels(train.runningDays).join(', '),
                        icon: Icons.event_repeat_rounded,
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(
            title:
                '${l10n.routeAndSchedule}  ·  ${l10n.stopsCount(route.length)}',
          ),
          AppCard(
            showShadow: false,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                for (var index = 0; index < route.length; index += 1) ...[
                  if (index == 0 ||
                      route[index].day != route[index - 1].day)
                    _DayDivider(
                      label: l10n.dayNumber(route[index].day),
                      first: index == 0,
                    ),
                  _RouteRow(
                    station: route[index],
                    isFirst: index == 0,
                    isLast: index == route.length - 1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.label, required this.first});

  final String label;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(top: first ? 8 : 14, bottom: 6, left: 36),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.textMuted,
              letterSpacing: 0.8,
              fontSize: 9.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: palette.border, height: 1)),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.station,
    required this.isFirst,
    required this.isLast,
  });

  final RouteStation station;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isEndpoint = isFirst || isLast;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 12,
                  color: isFirst ? Colors.transparent : palette.border,
                ),
                Container(
                  width: isEndpoint ? 11 : 8,
                  height: isEndpoint ? 11 : 8,
                  decoration: BoxDecoration(
                    color: isEndpoint ? palette.primaryAction : palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isEndpoint ? palette.primaryAction : palette.border,
                      width: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : palette.border,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: isLast ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: isEndpoint
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (station.code != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: palette.surfaceAlt,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            station.code!,
                            style: textTheme.labelSmall?.copyWith(
                              color: palette.textSecondary,
                              letterSpacing: 0.5,
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 86,
                        child: Row(
                          children: [
                            Icon(
                              Icons.login_rounded,
                              size: 11,
                              color: palette.textMuted,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              displayTime(station.arrival) ?? '—',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 11,
                            color: palette.textMuted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            displayTime(station.departure) ?? '—',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (station.distanceKm > 0)
                        Text(
                          l10n.km(station.distanceKm.round().toString()),
                          style: textTheme.labelSmall?.copyWith(
                            color: palette.textMuted,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                  if (station.halt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.halt} ${station.halt}',
                      style: textTheme.labelSmall?.copyWith(
                        color: palette.textMuted,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

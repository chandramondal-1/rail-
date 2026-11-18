import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/utils/formatters.dart';
import 'package:railpulse/features/live_status/models/live_status.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';
import 'package:railpulse/shared/widgets/pulse_dot.dart';
import 'package:railpulse/shared/widgets/section_header.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';

class LiveStatusView extends StatefulWidget {
  const LiveStatusView({
    super.key,
    required this.trainNo,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 28),
  });

  final String trainNo;
  final EdgeInsetsGeometry padding;

  @override
  State<LiveStatusView> createState() => _LiveStatusViewState();
}

class _LiveStatusViewState extends State<LiveStatusView> {
  static const _refreshInterval = Duration(seconds: 60);

  late DateTime _date = _today;
  LiveStatus? _live;
  Object? _error;
  bool _loading = true;
  bool _isDemo = false;
  bool _showAllStops = false;
  Timer? _autoRefresh;

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _load();
    _autoRefresh = Timer.periodic(_refreshInterval, (_) {
      if (mounted && _live != null) _load(silent: true);
    });
  }

  @override
  void didUpdateWidget(covariant LiveStatusView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trainNo != widget.trainNo) {
      setState(() {
        _live = null;
        _error = null;
        _loading = true;
        _showAllStops = false;
      });
      _load();
    }
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final result = await context.read<AppServices>().live.fetch(
        widget.trainNo,
        formatApiDate(_date),
      );
      if (!mounted) return;
      setState(() {
        _live = result.data;
        _isDemo = result.isDemo;
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      if (silent && _live != null) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _today.subtract(const Duration(days: 7)),
      lastDate: _today.add(const Duration(days: 10)),
      helpText: AppLocalizations.of(context).selectDate,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    _load();
  }

  void _setDate(DateTime date) {
    if (date == _date) return;
    setState(() => _date = date);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return RefreshIndicator(
      color: palette.accent,
      backgroundColor: palette.card,
      onRefresh: _load,
      child: ListView(
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _DateBar(
            date: _date,
            today: _today,
            onSelect: _setDate,
            onPick: _pickDate,
          ),
          const SizedBox(height: 14),
          if (_loading)
            const Column(
              children: [
                SkeletonBox(width: double.infinity, height: 176, radius: 20),
                SizedBox(height: 14),
                SkeletonList(items: 4),
              ],
            )
          else if (_error != null)
            AppCard(
              showShadow: false,
              child: AppErrorView(error: _error!, onRetry: _load),
            )
          else if (_live != null) ...[
            DemoBanner(isDemo: _isDemo, margin: const EdgeInsets.only(bottom: 14)),
            _StatusHero(live: _live!, onRefresh: _load),
            const SizedBox(height: 22),
            SectionHeader(title: l10n.routeAndSchedule),
            _StopsCard(
              live: _live!,
              showAll: _showAllStops,
              onToggle: () =>
                  setState(() => _showAllStops = !_showAllStops),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sync_rounded,
                  size: 13,
                  color: palette.textMuted,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    l10n.autoRefreshNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DateBar extends StatelessWidget {
  const _DateBar({
    required this.date,
    required this.today,
    required this.onSelect,
    required this.onPick,
  });

  final DateTime date;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final options = <(DateTime, String)>[
      (yesterday, l10n.yesterday),
      (today, l10n.today),
      (tomorrow, l10n.tomorrow),
    ];

    final isCustom = !options.any((entry) => entry.$1 == date);

    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final option in options) ...[
                  _DateChip(
                    label: option.$2,
                    selected: option.$1 == date,
                    onTap: () => onSelect(option.$1),
                  ),
                  const SizedBox(width: 8),
                ],
                if (isCustom)
                  _DateChip(
                    label: formatFriendlyDate(date),
                    selected: true,
                    onTap: () {},
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: palette.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPick,
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: selected ? palette.primaryAction : palette.surfaceAlt,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? palette.onPrimaryAction : palette.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.live, required this.onRefresh});

  final LiveStatus live;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final progress = live.progress;
    final delayed = live.delayMinutes > 0;
    final updated = parseTimestamp(live.lastUpdated);

    final stateLabel = progress.isCompleted
        ? l10n.journeyCompleted
        : progress.notStarted
        ? l10n.notStarted
        : l10n.liveBadge;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.isDark
              ? [const Color(0xFF1B2B45), const Color(0xFF101828)]
              : [const Color(0xFF101828), const Color(0xFF1E3050)],
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!progress.isCompleted && !progress.notStarted)
                      const PulseDot(size: 6, active: true)
                    else
                      const SizedBox(width: 2),
                    Text(
                      stateLabel.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (updated != null)
                Text(
                  l10n.updatedAt(formatClock(updated)),
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: l10n.refresh,
                onPressed: () => onRefresh(),
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            live.statusNote ?? l10n.noLiveData,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${live.trainNo} · ${live.trainName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: l10n.currentStation,
                  value: live.currentStop?.name ??
                      live.currentStationName ??
                      '—',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _HeroMetric(
                  label: l10n.nextStation,
                  value: live.nextStop?.name ?? '—',
                ),
              ),
              const SizedBox(width: 12),
              StatusPill(
                label: delayed ? '+${live.delayMinutes}m' : l10n.onTime,
                background: delayed
                    ? const Color(0x33F59E0B)
                    : const Color(0x3322C55E),
                foreground: delayed
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFF4ADE80),
                icon: delayed
                    ? Icons.schedule_rounded
                    : Icons.check_circle_outline_rounded,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (progress.percent / 100).clamp(0, 1),
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF22C55E),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                distanceLabel(progress.currentDistanceKm),
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const Spacer(),
              Text(
                '${progress.percent.toStringAsFixed(0)}%',
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF4ADE80),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                distanceLabel(live.totalDistanceKm),
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.48),
            letterSpacing: 0.5,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StopsCard extends StatelessWidget {
  const _StopsCard({
    required this.live,
    required this.showAll,
    required this.onToggle,
  });

  final LiveStatus live;
  final bool showAll;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final stops = live.stops;
    final visible = showAll ? stops : stops.take(8).toList(growable: false);

    return AppCard(
      showShadow: false,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.stopsCount(stops.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
              if (live.lastPassedStop != null)
                Text(
                  '${l10n.lastUpdated}: '
                  '${displayTime(live.lastPassedStop!.departure.actual) ?? '—'}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.textMuted,
                    fontSize: 9.5,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < visible.length; index += 1)
            _StopRow(
              stop: visible[index],
              isFirst: index == 0,
              isLast: index == visible.length - 1,
            ),
          if (stops.length > 8)
            Center(
              child: TextButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  showAll
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                ),
                label: Text(
                  showAll ? l10n.hideStations : l10n.showAllStations,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: palette.accent,
                  textStyle: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.stop,
    required this.isFirst,
    required this.isLast,
  });

  final LiveStop stop;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final current = stop.isCurrent;
    final passed = stop.isPassed;
    final delayed = stop.delayMinutes > 0;

    final dotColor = current
        ? palette.accent
        : passed
        ? palette.textMuted
        : palette.border;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 26,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 6,
                  color: isFirst ? Colors.transparent : palette.border,
                ),
                Container(
                  width: current ? 12 : 9,
                  height: current ? 12 : 9,
                  decoration: BoxDecoration(
                    color: current ? palette.accent : palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
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
              padding: EdgeInsets.only(top: 4, bottom: isLast ? 12 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stop.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: current
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: passed
                                ? palette.textSecondary
                                : palette.textPrimary,
                          ),
                        ),
                      ),
                      if (stop.platform != null)
                        StatusPill(
                          label: l10n.platformNumber(stop.platform!),
                          background: palette.surfaceAlt,
                          foreground: palette.textSecondary,
                          dense: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '${l10n.arrival} ${displayTime(stop.arrival.actual) ?? '—'}',
                        style: textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${l10n.departure} ${displayTime(stop.departure.actual) ?? '—'}',
                        style: textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (delayed) ...[
                        const SizedBox(width: 8),
                        Text(
                          '+${stop.delayMinutes}m',
                          style: textTheme.labelSmall?.copyWith(
                            color: palette.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (stop.distanceKm > 0)
                        Text(
                          distanceLabel(stop.distanceKm),
                          style: textTheme.labelSmall?.copyWith(
                            color: palette.textMuted,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

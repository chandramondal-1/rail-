import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_routes.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/utils/formatters.dart';
import 'package:railpulse/features/station_status/models/station_board.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/station_summary.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';

class StationBoardScreen extends StatefulWidget {
  const StationBoardScreen({super.key, this.station});

  final StationSummary? station;

  @override
  State<StationBoardScreen> createState() => _StationBoardScreenState();
}

class _StationBoardScreenState extends State<StationBoardScreen> {
  static const _popular = ['NDLS', 'CSMT', 'HWH', 'MAS', 'SBC', 'ADI'];

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _debounce;

  StationSummary? _station;
  StationBoard? _board;
  List<StationSummary> _suggestions = const [];
  Object? _boardError;
  Object? _searchError;
  bool _loadingBoard = false;
  bool _searching = false;
  bool _loadingSearch = false;
  bool _isDemo = false;
  int _hours = 2;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _station = widget.station;
    if (_station == null) {
      _openSearch();
    } else {
      _loadBoard();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() {
      _searching = true;
      _suggestions = const [];
      _searchError = null;
      _query = '';
      _searchController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  void _closeSearch() {
    if (_station == null) return;
    setState(() => _searching = false);
    _searchFocus.unfocus();
  }

  Future<void> _loadBoard({bool silent = false}) async {
    final station = _station;
    if (station == null) return;

    if (!silent) {
      setState(() {
        _loadingBoard = true;
        _boardError = null;
      });
    }

    try {
      final result = await context.read<AppServices>().stations.board(
        station.code,
        _hours,
      );
      if (!mounted) return;
      setState(() {
        _board = result.data;
        _isDemo = result.isDemo;
        _station = result.data.station.code.isNotEmpty
            ? result.data.station
            : station;
        _loadingBoard = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _boardError = error;
        _loadingBoard = false;
      });
    }
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _suggestions = const [];
        _searchError = null;
        _loadingSearch = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), _searchStations);
  }

  Future<void> _searchStations() async {
    final query = _query.trim();
    if (query.length < 2) return;
    setState(() {
      _loadingSearch = true;
      _searchError = null;
    });
    try {
      final result = await context.read<AppServices>().stations.search(query);
      if (!mounted) return;
      setState(() {
        _suggestions = result.data;
        _isDemo = result.isDemo;
        _loadingSearch = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _searchError = error;
        _loadingSearch = false;
      });
    }
  }

  void _selectStation(StationSummary station) {
    _searchFocus.unfocus();
    setState(() {
      _station = station;
      _searching = false;
      _query = '';
      _searchController.clear();
    });
    _loadBoard();
  }

  void _setHours(int hours) {
    if (hours == _hours) return;
    setState(() => _hours = hours);
    _loadBoard();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final station = _station;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          station == null || _searching
              ? l10n.stationStatus
              : '${station.name}  ·  ${station.code}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: _searching && station != null
            ? IconButton(
                tooltip: l10n.close,
                onPressed: _closeSearch,
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        actions: [
          if (!_searching)
            IconButton(
              tooltip: l10n.searchStation,
              onPressed: _openSearch,
              icon: const Icon(Icons.search_rounded),
            ),
          if (station != null && !_searching)
            IconButton(
              tooltip: l10n.refresh,
              onPressed: _loadBoard,
              icon: const Icon(Icons.refresh_rounded),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: _searching ? _buildSearch(l10n, palette) : _buildBoard(l10n, palette),
    );
  }

  Widget _buildSearch(AppLocalizations l10n, AppPalette palette) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            onChanged: _onQueryChanged,
            onSubmitted: (_) => _searchStations(),
            decoration: InputDecoration(
              hintText: l10n.stationSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.clear,
                      onPressed: () {
                        _searchController.clear();
                        _onQueryChanged('');
                        _searchFocus.requestFocus();
                      },
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
            ),
          ),
        ),
        if (_query.trim().length < 2)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                Text(
                  l10n.popularStations.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final code in _popular)
                      ActionChip(
                        onPressed: () => _selectStation(
                          StationSummary(code: code, name: code),
                        ),
                        label: Text(code),
                        labelStyle: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: palette.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                        backgroundColor: palette.surfaceAlt,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                AppCard(
                  showShadow: false,
                  padding: EdgeInsets.zero,
                  child: EmptyState(
                    icon: Icons.location_on_outlined,
                    title: l10n.stationEmptyTitle,
                    body: l10n.stationEmptyBody,
                    compact: true,
                  ),
                ),
              ],
            ),
          )
        else if (_loadingSearch)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SkeletonList(items: 4),
          )
        else if (_searchError != null)
          Expanded(
            child: SingleChildScrollView(
              child: AppErrorView(error: _searchError!, onRetry: _searchStations),
            ),
          )
        else if (_suggestions.isEmpty)
          Expanded(
            child: SingleChildScrollView(
              child: EmptyState(
                icon: Icons.location_off_outlined,
                title: l10n.stationNotFound,
                body: l10n.stationNotFoundBody,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final station = _suggestions[index];
                return Material(
                  color: palette.card,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _selectStation(station),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: palette.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 19,
                            color: palette.success,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  station.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                if (station.city != null)
                                  Text(
                                    station.city!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: palette.textSecondary,
                                          fontSize: 11,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            station.code,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: palette.textMuted,
                                  letterSpacing: 0.6,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBoard(AppLocalizations l10n, AppPalette palette) {
    if (_loadingBoard) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            SkeletonBox(width: double.infinity, height: 96, radius: 20),
            SizedBox(height: 14),
            SkeletonList(items: 5),
          ],
        ),
      );
    }

    if (_boardError != null) {
      return RefreshIndicator(
        onRefresh: _loadBoard,
        color: palette.accent,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              showShadow: false,
              child: AppErrorView(error: _boardError!, onRetry: _loadBoard),
            ),
          ],
        ),
      );
    }

    final board = _board;
    if (board == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _loadBoard,
      color: palette.accent,
      backgroundColor: palette.card,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          DemoBanner(isDemo: _isDemo, margin: const EdgeInsets.only(bottom: 14)),
          _BoardHeader(
            board: board,
            hours: _hours,
            onHours: _setHours,
            onRefresh: _loadBoard,
          ),
          const SizedBox(height: 16),
          if (board.trains.isEmpty)
            AppCard(
              showShadow: false,
              padding: EdgeInsets.zero,
              child: EmptyState(
                icon: Icons.departure_board_outlined,
                title: l10n.noTrainsWindow,
                body: l10n.noTrainsWindowBody,
                compact: true,
              ),
            )
          else
            for (var index = 0; index < board.trains.length; index += 1) ...[
              _BoardTrainTile(train: board.trains[index]),
              if (index != board.trains.length - 1) const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _BoardHeader extends StatelessWidget {
  const _BoardHeader({
    required this.board,
    required this.hours,
    required this.onHours,
    required this.onRefresh,
  });

  final StationBoard board;
  final int hours;
  final ValueChanged<int> onHours;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final updated = board.updatedAt;

    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.departure_board_rounded,
                  size: 21,
                  color: palette.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      board.station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        board.station.code,
                        l10n.nextHours(hours),
                      ].join('  ·  '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (updated != null)
                StatusPill(
                  label: formatClock(updated),
                  background: palette.surfaceAlt,
                  foreground: palette.textSecondary,
                  icon: Icons.schedule_rounded,
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final option in const [2, 4, 8]) ...[
                  Material(
                    color: option == hours
                        ? palette.primaryAction
                        : palette.surfaceAlt,
                    borderRadius: BorderRadius.circular(11),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onTap: () => onHours(option),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        child: Text(
                          l10n.nextHours(option),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: option == hours
                                    ? palette.onPrimaryAction
                                    : palette.textSecondary,
                                fontWeight: option == hours
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardTrainTile extends StatelessWidget {
  const _BoardTrainTile({required this.train});

  final BoardTrain train;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final delayed = train.arrival.isDelayed || train.departure.isDelayed;
    final delay = train.departure.delayMinutes > 0
        ? train.departure.delayMinutes
        : train.arrival.delayMinutes;
    final showsArrival = train.endsHere;
    final primaryTime = showsArrival ? train.arrival : train.departure;
    final primaryLabel = showsArrival ? l10n.arrivals : l10n.departures;

    return AppCard(
      showShadow: false,
      padding: const EdgeInsets.all(14),
      onTap: () => openTrain(
        context,
        TrainSummary(
          number: train.trainNo,
          name: train.trainName,
          type: train.trainType,
          source: train.source,
          sourceName: train.sourceName,
          destination: train.destinationCode,
          destinationName: train.destinationName,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTime(primaryTime.scheduled) ??
                      displayTime(train.arrival.scheduled) ??
                      displayTime(train.departure.scheduled) ??
                      '—',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  primaryLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: palette.textMuted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 46,
            color: palette.border,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        train.trainName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      train.trainNo,
                      style: textTheme.labelSmall?.copyWith(
                        color: palette.textMuted,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  _routeLabel(train),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    if (train.platform != null)
                      StatusPill(
                        label: l10n.platformNumber(train.platform!),
                        background: palette.accentSoft,
                        foreground: palette.success,
                        dense: true,
                      ),
                    if (train.platform != null) const SizedBox(width: 6),
                    if (train.startsHere)
                      StatusPill(
                        label: l10n.startsHere,
                        background: palette.surfaceAlt,
                        foreground: palette.textSecondary,
                        dense: true,
                      ),
                    if (train.endsHere) ...[
                      if (train.startsHere) const SizedBox(width: 6),
                      StatusPill(
                        label: l10n.endsHere,
                        background: palette.surfaceAlt,
                        foreground: palette.textSecondary,
                        dense: true,
                      ),
                    ],
                    const Spacer(),
                    if (delayed)
                      Text(
                        l10n.delayBy(delay),
                        style: textTheme.labelSmall?.copyWith(
                          color: palette.warning,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      )
                    else if (train.arrival.isDelayed == false &&
                        train.arrival.actual != null)
                      Text(
                        l10n.onTime,
                        style: textTheme.labelSmall?.copyWith(
                          color: palette.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _routeLabel(BoardTrain train) {
    if (train.routeLabel != null && train.routeLabel!.isNotEmpty) {
      return train.routeLabel!;
    }
    final from = train.fromLabel;
    final to = train.toLabel;
    if (from.isEmpty && to.isEmpty) return '';
    return '$from → $to';
  }
}

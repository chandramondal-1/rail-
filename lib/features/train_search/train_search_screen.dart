import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_routes.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/station_summary.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/segmented_control.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/train_list_tile.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';

enum SearchTab { trains, stations }

class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({
    super.key,
    this.initialTab = SearchTab.trains,
    this.openRoute = false,
  });

  final SearchTab initialTab;
  final bool openRoute;

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  late SearchTab _tab = widget.initialTab;
  List<TrainSummary> _trains = const [];
  List<StationSummary> _stations = const [];
  Object? _error;
  bool _loading = false;
  bool _isDemo = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _canSearch => _query.trim().length >= 2;

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      if (!_canSearch) {
        _trains = const [];
        _stations = const [];
        _error = null;
        _loading = false;
      }
    });
    _debounce?.cancel();
    if (!_canSearch) return;
    _debounce = Timer(const Duration(milliseconds: 450), _search);
  }

  Future<void> _search() async {
    final query = _query.trim();
    if (query.length < 2) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final services = context.read<AppServices>();
    try {
      if (_tab == SearchTab.trains) {
        final result = await services.search.search(query);
        if (!mounted) return;
        setState(() {
          _trains = result.data;
          _isDemo = result.isDemo;
          _loading = false;
        });
      } else {
        final result = await services.stations.search(query);
        if (!mounted) return;
        setState(() {
          _stations = result.data;
          _isDemo = result.isDemo;
          _loading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _setTab(SearchTab tab) {
    if (tab == _tab) return;
    setState(() {
      _tab = tab;
      _trains = const [];
      _stations = const [];
      _error = null;
    });
    if (_canSearch) _search();
  }

  Future<void> _openTrain(TrainSummary train) async {
    await context.read<AppState>().addRecent(train);
    if (!mounted) return;
    openTrain(context, train, initialTab: widget.openRoute ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchFor)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              children: [
                SegmentedControl(
                  labels: [l10n.trains, l10n.stations],
                  index: _tab.index,
                  onChanged: (index) => _setTab(SearchTab.values[index]),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  autocorrect: false,
                  onChanged: _onQueryChanged,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: _tab == SearchTab.trains
                        ? l10n.searchHint
                        : l10n.stationSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.clear,
                            onPressed: () {
                              _controller.clear();
                              _onQueryChanged('');
                              _focusNode.requestFocus();
                            },
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (_isDemo && !_loading && _error == null)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: DemoBanner(isDemo: true),
            ),
          Expanded(child: _buildBody(l10n, palette)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, AppPalette palette) {
    if (!_canSearch) {
      return EmptyState(
        icon: Icons.search_rounded,
        title: _tab == SearchTab.trains ? l10n.searchFor : l10n.searchStation,
        body: _tab == SearchTab.trains
            ? l10n.searchEmptyBody
            : l10n.stationEmptyBody,
      );
    }

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SkeletonList(items: 5),
      );
    }

    if (_error != null) {
      return Center(
        child: SingleChildScrollView(
          child: AppErrorView(error: _error!, onRetry: _search),
        ),
      );
    }

    if (_tab == SearchTab.trains) {
      if (_trains.isEmpty) {
        return EmptyState(
          icon: Icons.train_outlined,
          title: l10n.searchEmptyTitle,
          body: l10n.searchEmptyBody,
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: _trains.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final train = _trains[index];
          return TrainListTile(train: train, onTap: () => _openTrain(train));
        },
      );
    }

    if (_stations.isEmpty) {
      return EmptyState(
        icon: Icons.location_off_outlined,
        title: l10n.stationNotFound,
        body: l10n.stationNotFoundBody,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _stations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final station = _stations[index];
        return Material(
          color: palette.card,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => openStationBoard(context, station),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: palette.success,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          [station.code, station.city]
                              .whereType<String>()
                              .where((value) => value.isNotEmpty)
                              .join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: palette.textMuted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

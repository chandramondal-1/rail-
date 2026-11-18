import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/features/live_status/live_status_view.dart';
import 'package:railpulse/features/train_schedule/train_route_view.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_snackbar.dart';
import 'package:railpulse/shared/widgets/segmented_control.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({
    super.key,
    required this.train,
    this.initialTab = 0,
  });

  final TrainSummary train;
  final int initialTab;

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  late int _tab = widget.initialTab.clamp(0, 1);

  @override
  void initState() {
    super.initState();
    context.read<AppState>().setLastTracked(widget.train);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppState>().addRecent(widget.train);
    });
  }

  Future<void> _toggleFavourite() async {
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context);
    final added = await state.toggleFavourite(widget.train);
    if (!mounted) return;
    AppSnackbar.show(
      context,
      added ? l10n.addedToFavourites : l10n.removedFromFavourites,
      icon: added ? Icons.star_rounded : Icons.star_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final isFavourite = context.watch<AppState>().isFavourite(
      widget.train.number,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.train.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              [
                widget.train.number,
                if (widget.train.routeLabel.isNotEmpty) widget.train.routeLabel,
              ].join('  ·  '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isFavourite ? l10n.removeFavourite : l10n.addFavourite,
            onPressed: _toggleFavourite,
            icon: Icon(
              isFavourite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFavourite ? palette.warning : palette.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: SegmentedControl(
              labels: [l10n.liveStatus, l10n.route],
              index: _tab,
              onChanged: (index) => setState(() => _tab = index),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                LiveStatusView(trainNo: widget.train.number),
                TrainRouteView(train: widget.train),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

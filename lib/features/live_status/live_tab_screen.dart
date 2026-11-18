import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_routes.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/features/live_status/live_status_view.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/saved_train.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/primary_button.dart';
import 'package:railpulse/shared/widgets/section_header.dart';

class LiveTabScreen extends StatelessWidget {
  const LiveTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final tracked = state.lastTracked;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.liveTrainStatus,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => openTrainSearch(context),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: Text(l10n.changeTrain),
                  style: TextButton.styleFrom(
                    foregroundColor: AppPalette.of(context).accent,
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: tracked == null
                ? _LiveEmpty(recents: state.recents)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: _TrackedHeader(train: tracked),
                      ),
                      Expanded(
                        child: LiveStatusView(
                          key: ValueKey(tracked.number),
                          trainNo: tracked.number,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TrackedHeader extends StatelessWidget {
  const _TrackedHeader({required this.train});

  final SavedTrain train;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      showShadow: false,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 16,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.train_rounded,
              size: 20,
              color: palette.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  train.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    train.number,
                    if (train.routeLabel.isNotEmpty) train.routeLabel,
                  ].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).changeTrain,
            onPressed: () => openTrainSearch(context),
            icon: Icon(Icons.swap_horiz_rounded, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _LiveEmpty extends StatelessWidget {
  const _LiveEmpty({required this.recents});

  final List<SavedTrain> recents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: [
        AppCard(
          showShadow: false,
          padding: EdgeInsets.zero,
          child: EmptyState(
            icon: Icons.radar_rounded,
            title: l10n.selectTrainFirst,
            body: l10n.trackTrainBody,
            action: SizedBox(
              width: 190,
              child: PrimaryButton(
                label: l10n.trackTrain,
                icon: Icons.search_rounded,
                onPressed: () => openTrainSearch(context),
              ),
            ),
          ),
        ),
        if (recents.isNotEmpty) ...[
          const SizedBox(height: 24),
          SectionHeader(title: l10n.recentSearches),
          for (final train in recents) ...[
            Material(
              color: palette.card,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => openTrain(
                  context,
                  TrainSummary(
                    number: train.number,
                    name: train.name,
                    source: train.source,
                    destination: train.destination,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: palette.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${train.number} · ${train.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        l10n.track,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: palette.accent,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: palette.accent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

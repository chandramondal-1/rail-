import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';

class TrainListTile extends StatelessWidget {
  const TrainListTile({
    super.key,
    required this.train,
    this.onTap,
    this.trailing,
  });

  final TrainSummary train;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final route = _routeLabel();

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.train_rounded,
              size: 24,
              color: palette.success,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surfaceAlt,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        train.number,
                        style: textTheme.labelSmall?.copyWith(
                          color: palette.textSecondary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    if (train.type != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          train.type!.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: palette.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  train.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (route.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          route,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                      if (train.departure != null) ...[
                        Text(
                          '  ·  ',
                          style: textTheme.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                        Text(
                          train.departure!,
                          style: textTheme.labelSmall?.copyWith(
                            color: palette.textSecondary,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: palette.textMuted,
                size: 22,
              ),
        ],
      ),
    );
  }

  String _routeLabel() {
    final from = train.sourceName ?? train.source;
    final to = train.destinationName ?? train.destination;
    if (from == null && to == null) return '';
    if (from == null) return to!;
    if (to == null) return from;
    return '$from → $to';
  }
}

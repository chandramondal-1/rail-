import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';

class MiniRoute extends StatelessWidget {
  const MiniRoute({
    super.key,
    required this.fromLabel,
    required this.toLabel,
    this.fromCode,
    this.toCode,
    this.fromTime,
    this.toTime,
  });

  final String fromLabel;
  final String toLabel;
  final String? fromCode;
  final String? toCode;
  final String? fromTime;
  final String? toTime;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Endpoint(
            eyebrow: fromCode,
            label: fromLabel,
            time: fromTime,
            alignEnd: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: palette.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 1.4,
                    color: palette.border,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.train_rounded,
                      size: 15,
                      color: palette.accent,
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 1.4,
                    color: palette.border,
                  ),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: palette.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _Endpoint(
            eyebrow: toCode,
            label: toLabel,
            time: toTime,
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({
    this.eyebrow,
    required this.label,
    this.time,
    required this.alignEnd,
  });

  final String? eyebrow;
  final String label;
  final String? time;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          eyebrow ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: palette.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        if (time != null) ...[
          const SizedBox(height: 3),
          Text(
            time!,
            style: textTheme.labelSmall?.copyWith(
              color: palette.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ],
    );
  }
}

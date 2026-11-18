import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/l10n/app_localizations.dart';

class DemoBanner extends StatelessWidget {
  const DemoBanner({
    super.key,
    required this.isDemo,
    this.margin = EdgeInsets.zero,
  });

  final bool isDemo;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    if (!isDemo) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Padding(
      padding: margin,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.warningSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.warning.withValues(alpha: 0.28)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.science_outlined,
              size: 19,
              color: palette.warning,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.demoBadge,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.warning,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.demoNotice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                      height: 1.45,
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

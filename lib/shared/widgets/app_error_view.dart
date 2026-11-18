import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/widgets/primary_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
    this.action,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final isNetwork = error is ApiException && (error as ApiException).isNetworkError;
    final message = error is ApiException ? (error as ApiException).message : null;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: compact ? 18 : 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.dangerSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isNetwork ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              color: palette.danger,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isNetwork ? l10n.backendUnreachable : l10n.somethingWentWrong,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isNetwork ? l10n.backendUnreachableBody : (message ?? l10n.checkConnection),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 18),
            SecondaryButton(
              label: l10n.retry,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 4), action!],
        ],
      ),
    );
  }
}

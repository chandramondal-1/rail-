import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/features/pnr/models/pnr_result.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_error_view.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/primary_button.dart';
import 'package:railpulse/shared/widgets/skeleton.dart';
import 'package:railpulse/shared/widgets/stat_block.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';

class PnrScreen extends StatefulWidget {
  const PnrScreen({super.key});

  @override
  State<PnrScreen> createState() => _PnrScreenState();
}

class _PnrScreenState extends State<PnrScreen> {
  final _controller = TextEditingController();
  PnrResult? _result;
  Object? _error;
  bool _isDemo = false;
  bool _loading = false;
  String? _validationError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit([String? value]) async {
    final pnr = (value ?? _controller.text).trim();
    final l10n = AppLocalizations.of(context);

    if (!RegExp(r'^\d{10}$').hasMatch(pnr)) {
      setState(() {
        _validationError = l10n.pnrInvalid;
        _result = null;
        _error = null;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _validationError = null;
      _loading = true;
      _error = null;
    });

    try {
      final result = await context.read<AppServices>().pnr.fetch(pnr);
      if (!mounted) return;
      await context.read<AppState>().addRecentPnr(pnr);
      if (!mounted) return;
      setState(() {
        _result = result.data;
        _isDemo = result.isDemo;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _result = null;
        _loading = false;
      });
    }
  }

  void _useRecent(String pnr) {
    _controller.text = pnr;
    _submit(pnr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final recentPnrs = context.watch<AppState>().recentPnrs;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(l10n.pnrStatus, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            l10n.pnrEmptyBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            showShadow: false,
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.search,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: _submit,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.pnrNumber,
                    hintText: l10n.pnrHint,
                    counterText: '',
                    errorText: _validationError,
                    prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: l10n.checkPnr,
                  icon: Icons.search_rounded,
                  loading: _loading,
                  onPressed: _loading ? null : _submit,
                ),
              ],
            ),
          ),
          if (recentPnrs.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final pnr in recentPnrs)
                  ActionChip(
                    onPressed: () => _useRecent(pnr),
                    avatar: Icon(
                      Icons.history_rounded,
                      size: 15,
                      color: palette.textMuted,
                    ),
                    label: Text(pnr),
                    labelStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(
                          color: palette.textSecondary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                    backgroundColor: palette.surfaceAlt,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          if (_loading)
            const Column(
              children: [
                SkeletonBox(width: double.infinity, height: 118, radius: 20),
                SizedBox(height: 14),
                SkeletonList(items: 3),
              ],
            )
          else if (_error != null)
            AppCard(
              showShadow: false,
              child: AppErrorView(error: _error!, onRetry: _submit),
            )
          else if (_result != null) ...[
            DemoBanner(isDemo: _isDemo, margin: const EdgeInsets.only(bottom: 14)),
            _PnrResultCard(result: _result!),
          ] else
            AppCard(
              showShadow: false,
              padding: EdgeInsets.zero,
              child: EmptyState(
                icon: Icons.confirmation_number_outlined,
                title: l10n.pnrEmptyTitle,
                body: _isDemo ? l10n.demoPnrHint : l10n.pnrEmptyBody,
              ),
            ),
        ],
      ),
    );
  }
}

class _PnrResultCard extends StatelessWidget {
  const _PnrResultCard({required this.result});

  final PnrResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final journey = result.journey;

    return AppCard(
      showShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.train_rounded,
                  size: 22,
                  color: palette.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.trainName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.trainNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(
                label: 'PNR ${result.pnr}',
                background: palette.surfaceAlt,
                foreground: palette.textSecondary,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatBlock(
                  label: l10n.source,
                  value: journey.source?.label ?? '—',
                  icon: Icons.trip_origin_rounded,
                ),
              ),
              Expanded(
                child: StatBlock(
                  label: l10n.destination,
                  value: journey.destination?.label ?? '—',
                  icon: Icons.place_rounded,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: palette.border, height: 1),
          const SizedBox(height: 4),
          if (journey.dateOfJourney != null)
            DetailRow(label: l10n.journeyDate, value: journey.dateOfJourney!),
          if (journey.classCode != null)
            DetailRow(label: l10n.classLabel, value: journey.classCode!),
          if (journey.quota != null)
            DetailRow(label: l10n.quota, value: journey.quota!),
          if (result.chartStatus != null)
            DetailRow(
              label: l10n.chartStatus,
              value: result.chartStatus!,
              valueColor: _chartColor(result.chartStatus!, palette),
            ),
          if (result.fare != null)
            DetailRow(
              label: l10n.bookingFare,
              value: '₹${result.fare}',
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                l10n.passengers,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: '${result.passengers.length}',
                background: palette.surfaceAlt,
                foreground: palette.textSecondary,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final passenger in result.passengers)
            _PassengerRow(passenger: passenger),
        ],
      ),
    );
  }

  Color _chartColor(String status, AppPalette palette) {
    final text = status.toLowerCase();
    if (text.contains('prepared')) return palette.success;
    return palette.warning;
  }
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow({required this.passenger});

  final PnrPassenger passenger;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final current = passenger.current;
    final status = current.status ?? passenger.booking.status ?? '—';
    final color = _statusColor(status, palette);

    final location = [
      if (current.coach != null) current.coach!,
      if (current.berthNo != null) '${current.berthNo}',
      if (current.berthCode != null) current.berthCode!,
    ].where((value) => value.isNotEmpty).join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            passenger.serialNumber,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.textMuted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (location.isNotEmpty)
            Text(
              location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Color _statusColor(String status, AppPalette palette) {
    final text = status.toUpperCase();
    if (text.contains('CNF') || text.contains('CONF')) return palette.success;
    if (text.contains('WL') || text.contains('RAC')) return palette.warning;
    return palette.textPrimary;
  }
}

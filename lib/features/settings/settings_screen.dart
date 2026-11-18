import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_services.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/config/app_config.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/features/settings/data/health_service.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_snackbar.dart';
import 'package:railpulse/shared/widgets/segmented_control.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ProviderHealth? _health;
  bool _loadingHealth = true;

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    setState(() => _loadingHealth = true);
    try {
      final health = await context.read<AppServices>().health.check();
      if (!mounted) return;
      setState(() {
        _health = health;
        _loadingHealth = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _health = null;
        _loadingHealth = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCache),
        content: Text(l10n.clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<AppState>().clearCache();
    if (!mounted) return;
    AppSnackbar.show(context, l10n.cacheCleared, icon: Icons.delete_outline);
  }

  Future<void> _editServer() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: context.read<AppState>().apiBaseUrl ?? '',
    );
    final saved = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.apiServer),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.apiServerBody,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppPalette.of(context).textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: l10n.apiServerHint),
            ),
            const SizedBox(height: 10),
            Text(
              '${l10n.apiServer}: ${AppConfig.apiBaseUrl}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppPalette.of(context).textMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: Text(l10n.reset),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || saved == null) return;
    await context.read<AppState>().setApiBaseUrl(saved);
    if (!mounted) return;
    await _loadHealth();
    if (!mounted) return;
    AppSnackbar.show(context, l10n.serverSaved, icon: Icons.dns_rounded);
  }

  void _showInfo(String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppPalette.of(context).surface,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 32),
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppPalette.of(context).textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final state = context.watch<AppState>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          Text(l10n.settings, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          _SectionLabel(label: l10n.appearance),
          AppCard(
            showShadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                SegmentedControl(
                  labels: [l10n.themeSystem, l10n.themeLight, l10n.themeDark],
                  index: switch (state.themeMode) {
                    ThemeMode.light => 1,
                    ThemeMode.dark => 2,
                    ThemeMode.system => 0,
                  },
                  onChanged: (index) {
                    final mode = switch (index) {
                      1 => ThemeMode.light,
                      2 => ThemeMode.dark,
                      _ => ThemeMode.system,
                    };
                    context.read<AppState>().setThemeMode(mode);
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                _LanguageRow(
                  label: l10n.languageEnglish,
                  selected: state.locale.languageCode == 'en',
                  onTap: () =>
                      context.read<AppState>().setLocale(const Locale('en')),
                ),
                _LanguageRow(
                  label: l10n.languageHindi,
                  selected: state.locale.languageCode == 'hi',
                  onTap: () =>
                      context.read<AppState>().setLocale(const Locale('hi')),
                ),
                _LanguageRow(
                  label: l10n.languageBengali,
                  selected: state.locale.languageCode == 'bn',
                  onTap: () =>
                      context.read<AppState>().setLocale(const Locale('bn')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: l10n.notifications),
          AppCard(
            showShadow: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 20,
                      color: palette.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.notificationsBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Switch(
                      value: state.notificationsEnabled,
                      onChanged: (value) =>
                          context.read<AppState>().setNotifications(value),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.notificationsNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: l10n.dataAndPrivacy),
          AppCard(
            showShadow: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dataSource,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _loadingHealth
                                ? l10n.loading
                                : _health == null
                                ? l10n.backendUnreachable
                                : _health!.isDemo
                                ? l10n.dataSourceDemo
                                : l10n.dataSourceLive,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: palette.textSecondary,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (_loadingHealth)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.accent,
                        ),
                      )
                    else if (_health != null)
                      StatusPill(
                        label: _health!.isDemo ? l10n.demoMode : l10n.liveData,
                        background: _health!.isDemo
                            ? palette.warningSoft
                            : palette.accentSoft,
                        foreground: _health!.isDemo
                            ? palette.warning
                            : palette.success,
                        icon: _health!.isDemo
                            ? Icons.science_outlined
                            : Icons.sensors_rounded,
                        dense: true,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: palette.border, height: 1),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _editServer,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.apiServer,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: palette.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            state.apiBaseUrl ?? AppConfig.apiBaseUrl,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: palette.textMuted),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit_outlined,
                          size: 15,
                          color: palette.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: palette.border, height: 1),
                const SizedBox(height: 4),
                _SettingsRow(
                  icon: Icons.delete_outline_rounded,
                  label: l10n.clearCache,
                  onTap: _clearCache,
                  destructive: true,
                ),
                _SettingsRow(
                  icon: Icons.shield_outlined,
                  label: l10n.privacy,
                  onTap: () => _showInfo(l10n.privacy, l10n.privacyBody),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: l10n.about),
          AppCard(
            showShadow: false,
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.info_outline_rounded,
                  label: l10n.about,
                  onTap: () => _showInfo(l10n.about, l10n.aboutBody),
                ),
                _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  label: l10n.help,
                  onTap: () => _showInfo(l10n.help, l10n.helpBody),
                ),
                _SettingsRow(
                  icon: Icons.report_gmailerrorred_rounded,
                  label: l10n.disclaimer,
                  onTap: () => _showInfo(l10n.disclaimer, l10n.disclaimerBody),
                ),
                Divider(color: palette.border, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        l10n.version,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppConfig.appVersion,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: palette.textMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              'RailPulse · ${l10n.tagline}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textMuted,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppPalette.of(context).textMuted,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 18, color: palette.accent)
            else
              Icon(
                Icons.circle_outlined,
                size: 18,
                color: palette.border,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final color = destructive ? palette.danger : palette.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: destructive ? palette.danger : palette.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: palette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

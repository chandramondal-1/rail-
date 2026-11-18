import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_colors.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.hero,
    required this.onHero,
    required this.primaryAction,
    required this.onPrimaryAction,
    required this.shadow,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color hero;
  final Color onHero;
  final Color primaryAction;
  final Color onPrimaryAction;
  final Color shadow;
  final bool isDark;

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  static const light = AppPalette(
    background: AppColors.canvas,
    surface: AppColors.white,
    surfaceAlt: Color(0xFFF1F5F9),
    card: AppColors.white,
    border: AppColors.line,
    textPrimary: AppColors.navy,
    textSecondary: Color(0xFF475467),
    textMuted: AppColors.slateLight,
    accent: AppColors.emerald,
    accentSoft: Color(0xFFDCFCE7),
    success: AppColors.emeraldDark,
    successSoft: Color(0xFFDCFCE7),
    warning: AppColors.warning,
    warningSoft: AppColors.amberSoft,
    danger: AppColors.danger,
    dangerSoft: Color(0xFFFEE2E2),
    hero: AppColors.navy,
    onHero: AppColors.white,
    primaryAction: AppColors.navy,
    onPrimaryAction: AppColors.white,
    shadow: Color(0x14101828),
    isDark: false,
  );

  static const dark = AppPalette(
    background: Color(0xFF0B1220),
    surface: Color(0xFF111A2C),
    surfaceAlt: Color(0xFF18233A),
    card: Color(0xFF111A2C),
    border: Color(0xFF223049),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFB4C0D3),
    textMuted: Color(0xFF7C8AA0),
    accent: AppColors.emeraldBright,
    accentSoft: Color(0xFF10301F),
    success: AppColors.emeraldBright,
    successSoft: Color(0xFF0E2E20),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF352708),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF391619),
    hero: Color(0xFF18243A),
    onHero: Color(0xFFF8FAFC),
    primaryAction: AppColors.emerald,
    onPrimaryAction: Color(0xFF052E16),
    shadow: Color(0x66000000),
    isDark: true,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? card,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? hero,
    Color? onHero,
    Color? primaryAction,
    Color? onPrimaryAction,
    Color? shadow,
    bool? isDark,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      card: card ?? this.card,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      hero: hero ?? this.hero,
      onHero: onHero ?? this.onHero,
      primaryAction: primaryAction ?? this.primaryAction,
      onPrimaryAction: onPrimaryAction ?? this.onPrimaryAction,
      shadow: shadow ?? this.shadow,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      onPrimaryAction: Color.lerp(onPrimaryAction, other.onPrimaryAction, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

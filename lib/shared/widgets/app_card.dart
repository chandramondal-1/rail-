import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.radius = 20,
    this.borderColor,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final Color? borderColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final radiusValue = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? palette.card,
        borderRadius: radiusValue,
        border: Border.all(color: borderColor ?? palette.border),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: palette.isDark ? 18 : 26,
                  offset: const Offset(0, 10),
                  spreadRadius: -12,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radiusValue,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

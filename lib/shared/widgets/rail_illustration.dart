import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_palette.dart';

class RailPulseMark extends StatelessWidget {
  const RailPulseMark({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: palette.hero,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.train_rounded,
            size: size * 0.52,
            color: palette.onHero,
          ),
          Positioned(
            right: size * 0.16,
            bottom: size * 0.16,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: palette.accent,
                shape: BoxShape.circle,
                border: Border.all(color: palette.hero, width: size * 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RailwayIllustration extends StatelessWidget {
  const RailwayIllustration({super.key, this.width = 220});

  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return SizedBox(
      width: width,
      height: width * 0.42,
      child: CustomPaint(
        painter: _RailwayPainter(
          rail: palette.border,
          sleeper: palette.border.withValues(alpha: 0.7),
          train: palette.hero,
          accent: palette.accent,
          window: palette.surface,
        ),
      ),
    );
  }
}

class _RailwayPainter extends CustomPainter {
  _RailwayPainter({
    required this.rail,
    required this.sleeper,
    required this.train,
    required this.accent,
    required this.window,
  });

  final Color rail;
  final Color sleeper;
  final Color train;
  final Color accent;
  final Color window;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final railY = h * 0.82;

    final railPaint = Paint()
      ..color = rail
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.04, railY), Offset(w * 0.96, railY), railPaint);
    canvas.drawLine(
      Offset(w * 0.04, railY + 8),
      Offset(w * 0.96, railY + 8),
      railPaint,
    );

    final sleeperPaint = Paint()
      ..color = sleeper
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (var x = 0.08; x < 0.97; x += 0.11) {
      canvas.drawLine(
        Offset(w * x, railY - 2),
        Offset(w * x, railY + 10),
        sleeperPaint,
      );
    }

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.34, w * 0.46, h * 0.34),
      Radius.circular(h * 0.12),
    );
    canvas.drawRRect(body, Paint()..color = train);

    final nose = Path()
      ..moveTo(w * 0.74, h * 0.34)
      ..quadraticBezierTo(w * 0.86, h * 0.42, w * 0.86, h * 0.68)
      ..lineTo(w * 0.74, h * 0.68)
      ..close();
    canvas.drawPath(nose, Paint()..color = train);

    final stripe = Paint()..color = accent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.3, h * 0.54, w * 0.54, h * 0.055),
        Radius.circular(h * 0.03),
      ),
      stripe,
    );

    final windowPaint = Paint()..color = window.withValues(alpha: 0.92);
    for (var index = 0; index < 3; index += 1) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w * (0.33 + index * 0.12),
            h * 0.4,
            w * 0.085,
            h * 0.095,
          ),
          Radius.circular(h * 0.025),
        ),
        windowPaint,
      );
    }

    final wheelPaint = Paint()..color = train;
    canvas.drawCircle(Offset(w * 0.38, h * 0.72), h * 0.052, wheelPaint);
    canvas.drawCircle(Offset(w * 0.66, h * 0.72), h * 0.052, wheelPaint);
    canvas.drawCircle(
      Offset(w * 0.38, h * 0.72),
      h * 0.022,
      Paint()..color = rail,
    );
    canvas.drawCircle(
      Offset(w * 0.66, h * 0.72),
      h * 0.022,
      Paint()..color = rail,
    );

    canvas.drawCircle(
      Offset(w * 0.16, h * 0.58),
      h * 0.035,
      Paint()..color = accent.withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      Offset(w * 0.09, h * 0.66),
      h * 0.022,
      Paint()..color = accent.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(covariant _RailwayPainter oldDelegate) {
    return oldDelegate.rail != rail ||
        oldDelegate.train != train ||
        oldDelegate.accent != accent;
  }
}

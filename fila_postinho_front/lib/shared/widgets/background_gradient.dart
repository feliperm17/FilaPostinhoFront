import 'package:flutter/material.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[900]!,
                  Colors.grey[850]!,
                  Colors.grey[800]!,
                ]
              : [
                  Colors.blue[50]!,
                  Colors.white,
                  Colors.blue[50]!,
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HealthPatternPainter(
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class HealthPatternPainter extends CustomPainter {
  final Color color;

  HealthPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    final symbols = [
      _drawCross,
      _drawHeartbeat,
      _drawPlus,
    ];

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        final symbolIndex = ((i + j) / spacing).floor() % symbols.length;
        symbols[symbolIndex](canvas, Offset(i, j), paint);
      }
    }
  }

  void _drawCross(Canvas canvas, Offset center, Paint paint) {
    const size = 8.0;
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size),
      Offset(center.dx, center.dy + size),
      paint,
    );
  }

  void _drawHeartbeat(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    const width = 16.0;
    const height = 8.0;

    path.moveTo(center.dx - width, center.dy);
    path.lineTo(center.dx - width / 2, center.dy);
    path.lineTo(center.dx - width / 4, center.dy - height);
    path.lineTo(center.dx, center.dy + height);
    path.lineTo(center.dx + width / 4, center.dy - height);
    path.lineTo(center.dx + width / 2, center.dy);
    path.lineTo(center.dx + width, center.dy);

    canvas.drawPath(path, paint);
  }

  void _drawPlus(Canvas canvas, Offset center, Paint paint) {
    const size = 6.0;
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size),
      Offset(center.dx, center.dy + size),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

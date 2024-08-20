import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientBorder extends StatelessWidget {
  final double width;
  final double animationValue;
  final LinearGradient borderGradient;

  const GradientBorder({super.key, 
    required this.width,
    required this.animationValue,
    required this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        width: width,
        animationValue: animationValue,
        borderGradient: borderGradient,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double width;
  final double animationValue;
  final LinearGradient borderGradient;

  _GradientBorderPainter({
    required this.width,
    required this.animationValue,
    required this.borderGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final double effectiveAnimationValue =
        math.max(0.0, math.min(1.0, animationValue));

    final List<Color> rotatedColors =
        _rotateColors(borderGradient.colors, effectiveAnimationValue);

    final LinearGradient rotatedGradient = LinearGradient(
      colors: rotatedColors,
      tileMode: borderGradient.tileMode,
      begin: borderGradient.begin,
      end: borderGradient.end,
    );

    paint.shader = rotatedGradient
        .createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.shortestSide / 4),
    );

    // Fill the inside of the border with white color
    canvas.drawRRect(
      rRect,
      Paint()..color = Colors.black87.withOpacity(0.8),
    );

    // Draw the border
    canvas.drawRRect(
      rRect,
      paint,
    );
  }

 List<Color> _rotateColors(List<Color> colors, double value) {
  final int shift = (colors.length * value).toInt() % colors.length;
  return [
    ...colors.getRange(shift, colors.length),
    ...colors.getRange(0, shift),
  ];
}


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GradientBorderBox extends StatefulWidget {
  final Widget child;

  const GradientBorderBox({super.key, required this.child});

  @override
  _GradientBorderBoxState createState() => _GradientBorderBoxState();
}

class _GradientBorderBoxState extends State<GradientBorderBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // ignore: avoid_unnecessary_containers
        return Container(
          width: 100,
          height: 60,
          child: CustomPaint(
            painter: _GradientBorderPainter(
              width: 3,
              animationValue: _animation.value,
              borderGradient: const LinearGradient(
                colors: [
                  Color(0xFFE0E0E0),
                  Color(0xFFB0B0B0),
                  Color(0xFF747474),
                  Color(0xFF515151), 
                ],
                tileMode: TileMode.repeated,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

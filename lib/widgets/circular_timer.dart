import 'dart:math';

import 'package:flutter/material.dart';

class CircularTimer extends StatefulWidget {
  final double progress;
  const CircularTimer({super.key, required this.progress});

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<double>(
      begin: _animation.value,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0.0);
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
        return CustomPaint(
          painter: _RoundedCircularProgressPainter(progress: _animation.value),
        );
      },
    );
  }
}

class _RoundedCircularProgressPainter extends CustomPainter {
  final double progress;

  _RoundedCircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..strokeWidth = 14
          ..style = PaintingStyle.stroke;

    Paint foregroundPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 14
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    double adjustedProgress = 1 - progress;
    if (adjustedProgress > 0) {
      double startAngle = -pi / 2;
      double sweepAngle = -2 * pi * adjustedProgress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        foregroundPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RoundedCircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

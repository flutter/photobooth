import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template animated_pulse}
/// Widget that applies a pulse animation to its child.
/// {@endtemplate}
class AnimatedPulse extends StatefulWidget {
  /// {@macro animated_pulse}
  const AnimatedPulse({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// [Widget] that will have the pulse animation
  final Widget child;

  @override
  _AnimatedPulseState createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _controller.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.completed) {
        _timer = Timer(const Duration(milliseconds: 800), () {
          _delayAnimation(() {
            _controller.forward(from: 0);
          });
        });
      } else if (status == AnimationStatus.dismissed) {
        _delayAnimation(() {
          _controller.forward();
        });
      }
    });
  }

  void _delayAnimation(VoidCallback animate) {
    _timer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) animate.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PulsingPainter(_controller),
      child: widget.child,
    );
  }
}

/// Painter for the pulse animation
class PulsingPainter extends CustomPainter {
  PulsingPainter(this._animation) : super(repaint: _animation);
  final Animation<double> _animation;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    final color = PhotoboothColors.blue;

    final circleSize = rect.width / 2;
    final area = circleSize * circleSize;
    final radius = sqrt(area * _animation.value * 3);
    final opacity = (1.0 - (_animation.value).clamp(0.0, 1.0));
    final paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  bool shouldRepaint(PulsingPainter oldDelegate) {
    return true;
  }
}

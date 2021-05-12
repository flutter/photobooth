import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template pulsing_view}
/// Widget that applies a pulse animation to its child.
/// {@endtemplate}
class PulsingView extends StatefulWidget {
  /// {@macro pulsing_view}
  PulsingView({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// [Widget] that will have the pulse animation
  final Widget child;

  @override
  _PulsingViewState createState() => _PulsingViewState();
}

class _PulsingViewState extends State<PulsingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
      lowerBound: 0,
      upperBound: 1,
    )..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        delayAnimation(() => _controller.forward(from: 0));
      } else if (status == AnimationStatus.dismissed) {
        delayAnimation(() => _controller.forward());
      }
    });
  }

  void delayAnimation(VoidCallback animation) {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) animation.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PulsingPainting(_controller),
      child: widget.child,
    );
  }
}

class _PulsingPainting extends CustomPainter {
  _PulsingPainting(this._animation) : super(repaint: _animation);
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final color = PhotoboothColors.blue;

    final size = rect.width / 2;
    final area = size * size;
    final radius = sqrt(area * value * 3);
    final opacity = (1.0 - (value)).clamp(0.0, 1.0);
    final paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    circle(canvas, rect, _animation.value);
  }

  @override
  bool shouldRepaint(_PulsingPainting oldDelegate) {
    return true;
  }
}

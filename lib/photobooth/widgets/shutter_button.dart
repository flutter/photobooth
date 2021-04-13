import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _shutterCountdownDuration = Duration(seconds: 3);

class ShutterButton extends StatefulWidget {
  const ShutterButton({
    Key? key,
    required this.onCountdownComplete,
  }) : super(key: key);

  final VoidCallback onCountdownComplete;

  @override
  _ShutterButtonState createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onCountdownComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: _shutterCountdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return controller.isAnimating
            ? CountdownTimer(controller: controller)
            : CameraButton(onPressed: () => controller.reverse(from: 1));
      },
    );
  }
}

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({Key? key, required this.controller}) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final secondsRemaining =
        (_shutterCountdownDuration.inSeconds * controller.value).ceil();
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '$secondsRemaining',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w500,
                color: PhotoboothColors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: TimerPainter(animation: controller)),
          )
        ],
      ),
    );
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PhotoboothColors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/icons/camera_button_icon.png',
          height: 84,
          width: 84,
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  const TimerPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @visibleForTesting
  Color calculateColor(double progress) {
    if (progress <= 2) return PhotoboothColors.blue;
    if (progress <= 4) return PhotoboothColors.orange;
    return PhotoboothColors.green;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (1.0 - animation.value) * 2 * math.pi;
    final progressColor = calculateColor(progress);
    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Colors.white;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => false;
}

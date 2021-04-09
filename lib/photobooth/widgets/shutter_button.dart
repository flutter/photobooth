import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShutterButton extends StatefulWidget {
  ShutterButton({
    Key? key,
    required this.onAnimationFinished,
  }) : super(key: key);

  final VoidCallback onAnimationFinished;

  @override
  _ShutterButtonState createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton>
    with TickerProviderStateMixin {
  var displayAnimation = false;
  late AnimationController controller;
  String get timerString {
    var duration = (controller.duration! * controller.value).inSeconds;
    if (duration != 3) {
      duration = duration + 1;
    }
    return '${(duration % 60).toString().padLeft(1, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed) {
        // Add small delay to force the animation to finish
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onAnimationFinished.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.isAnimating) {
          return Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(bottom: 15),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    timerString,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      color: PhotoboothColors.white,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: TimerPainter(
                      animation: controller,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return CameraButton(
            onPressed: () {
              controller.reverse(
                from: 1,
              );
            },
          );
        }
      },
    );
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

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
  TimerPainter({
    required this.animation,
  }) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (1.0 - animation.value) * 2 * math.pi;
    Color progressColor;
    if (progress <= 2) {
      progressColor = PhotoboothColors.blue;
    } else if (progress <= 4) {
      progressColor = PhotoboothColors.orange;
    } else {
      progressColor = PhotoboothColors.green;
    }
    var paint = Paint()
      ..color = progressColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Colors.white;

    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(dynamic oldDelegate) {
    return true;
  }
}

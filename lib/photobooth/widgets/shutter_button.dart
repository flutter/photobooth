import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShutterButton extends StatefulWidget {
  ShutterButton({Key? key}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.isAnimating) {
          return Container(
            height: 100,
            width: 100,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    timerString,
                    style: const TextStyle(
                      fontSize: 74,
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
          return FloatingActionButton(
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

class TimerPainter extends CustomPainter {
  TimerPainter({
    required this.animation,
  }) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = PhotoboothColors.white
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Colors.red;
    final progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(dynamic oldDelegate) {
    return true;
  }
}

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
    final duration = controller.duration! * controller.value;

    print(duration.inSeconds.toString().padLeft(width));
    return '${(duration.inSeconds % 60).toString().padLeft(1, '0')}';
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
            color: Colors.amber,
            child: Text(
              timerString,
              style: const TextStyle(
                fontSize: 74,
                fontWeight: FontWeight.w500,
                color: PhotoboothColors.white,
              ),
            ),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              controller.forward();
            },
          );
        }
      },
    );
  }
}

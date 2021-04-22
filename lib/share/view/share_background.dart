import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBackground extends StatelessWidget {
  const ShareBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/backgrounds/share_background.jpg',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        PlatformBuilder(
          desktop: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/backgrounds/yellow_bar.png',
              filterQuality: FilterQuality.high,
            ),
          ),
          mobile: const SizedBox(),
        ),
        PlatformBuilder(
          desktop: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/backgrounds/circle_object.png',
              filterQuality: FilterQuality.high,
            ),
          ),
          mobile: const SizedBox(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBackground extends StatelessWidget {
  const ShareBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/backgrounds/photobooth_background.jpg',
            repeat: ImageRepeat.repeat,
            filterQuality: FilterQuality.high,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhotoboothColors.transparent,
                PhotoboothColors.black54,
              ],
            ),
          ),
        ),
        ResponsiveLayoutBuilder(
          large: (_, __) => Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/backgrounds/yellow_bar.png',
              filterQuality: FilterQuality.high,
            ),
          ),
          small: (_, __) => const SizedBox(),
        ),
        ResponsiveLayoutBuilder(
          large: (_, __) => Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/backgrounds/circle_object.png',
              filterQuality: FilterQuality.high,
            ),
          ),
          small: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

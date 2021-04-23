import 'package:flutter/material.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/backgrounds/photobooth_background.jpg',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        /*Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            'assets/backgrounds/yellow_plus_flat.png',
          ),
        ),*/
        /*Align(
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'assets/backgrounds/red_box.png',
          ),
        ),*/
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            'assets/backgrounds/blue_circle_flat.png',
            height: 100,
          ),
        ),
      ],
    );
  }
}

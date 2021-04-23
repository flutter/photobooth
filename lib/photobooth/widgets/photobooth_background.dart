import 'package:flutter/material.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/backgrounds/wood_background.png',
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}

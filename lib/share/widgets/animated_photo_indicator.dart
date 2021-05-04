import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedPhotoIndicator extends StatelessWidget {
  AnimatedPhotoIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimatedSprite(
      sprites: Sprites(
        asset: 'photo_indicator_spritesheet.png',
        size: Size(173, 163),
        frames: 51,
        stepTime: 0.05,
      ),
    );
  }
}

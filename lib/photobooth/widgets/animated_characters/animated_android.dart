import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedAndroid extends AnimatedSprite {
  const AnimatedAndroid({Key? key})
      : super(
          key: key,
          loadingIndicatorColor: PhotoboothColors.green,
          sprites: const Sprites(
            asset: 'android_spritesheet.png',
            size: Size(450, 658),
            frames: 25,
            stepTime: 2 / 25,
          ),
        );
}

import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';

class AnimatedAndroid extends AnimatedSprite {
  const AnimatedAndroid({Key? key})
      : super(
          key: key,
          sprites: const Sprites(
            asset: 'android_spritesheet.png',
            size: Size(592, 860),
            frames: 25,
          ),
        );
}

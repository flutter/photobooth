import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedSparky extends AnimatedSprite {
  const AnimatedSparky({Key? key})
      : super(
          key: key,
          sprites: const Sprites(
            asset: 'sparky_spritesheet.png',
            size: Size(730, 588),
            frames: 25,
            stepTime: 2 / 25,
          ),
        );
}

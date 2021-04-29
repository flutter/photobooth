import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';

class AnimatedSparky extends AnimatedSprite {
  const AnimatedSparky({Key? key})
      : super(
          key: key,
          sprites: const Sprites(
            asset: 'sparky_spritesheet.png',
            size: Size(1054, 849),
            frames: 25,
            stepTime: 2 / 25,
          ),
        );
}

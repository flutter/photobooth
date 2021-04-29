import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';

class AnimatedDino extends AnimatedSprite {
  const AnimatedDino({Key? key})
      : super(
          key: key,
          sprites: const Sprites(
            asset: 'dino_spritesheet.png',
            size: Size(837, 978),
            frames: 49,
            stepTime: 2 / 49,
          ),
        );
}

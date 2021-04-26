import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';

class AnimatedDash extends AnimatedSprite {
  const AnimatedDash({Key? key})
      : super(
          key: key,
          sprites: const Sprites(
            asset: 'dash_spritesheet.png',
            size: Size(881, 796),
            frames: 25,
          ),
        );
}

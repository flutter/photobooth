import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedDino extends AnimatedSprite {
  const AnimatedDino({Key? key})
      : super(
          key: key,
          loadingIndicatorColor: PhotoboothColors.orange,
          sprites: const Sprites(
            asset: 'dino_spritesheet.png',
            size: Size(648, 757),
            frames: 25,
            stepTime: 2 / 25,
          ),
        );
}

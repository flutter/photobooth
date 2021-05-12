import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedDash extends AnimatedSprite {
  const AnimatedDash({Key? key})
      : super(
          key: key,
          loadingIndicatorColor: PhotoboothColors.blue,
          sprites: const Sprites(
            asset: 'dash_spritesheet.png',
            size: Size(650, 587),
            frames: 25,
            stepTime: 2 / 25,
          ),
        );
}

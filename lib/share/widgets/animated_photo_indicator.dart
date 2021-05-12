import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _size = Size(173, 163);

class AnimatedPhotoIndicator extends StatelessWidget {
  const AnimatedPhotoIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(_size),
      child: const AnimatedSprite(
        sprites: Sprites(
          asset: 'photo_indicator_spritesheet.png',
          size: _size,
          frames: 51,
          stepTime: 0.05,
        ),
        showLoadingIndicator: false,
      ),
    );
  }
}

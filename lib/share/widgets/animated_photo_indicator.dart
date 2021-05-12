import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _size = Size(173, 163);

class AnimatedPhotoIndicator extends StatelessWidget {
  const AnimatedPhotoIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const _AnimatedPhotoIndicator(scale: 0.6),
      medium: (_, __) => const _AnimatedPhotoIndicator(scale: 0.7),
      large: (_, __) => const _AnimatedPhotoIndicator(scale: 1.0),
    );
  }
}

class _AnimatedPhotoIndicator extends StatelessWidget {
  const _AnimatedPhotoIndicator({
    Key? key,
    required this.scale,
  }) : super(key: key);
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(_size.width * scale, _size.height * scale),
      ),
      child: const AnimatedSprite(
        sprites: Sprites(
          asset: 'photo_indicator_spritesheet.png',
          size: _size,
          frames: 51,
          stepTime: 0.05,
        ),
      ),
    );
  }
}

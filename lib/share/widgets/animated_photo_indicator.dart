import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _size = Size(173, 163);

class AnimatedPhotoIndicator extends StatelessWidget {
  const AnimatedPhotoIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const _AnimatedPhotoIndicator(scale: 0.6),
      medium: (_, __) => const _AnimatedPhotoIndicator(scale: 0.7),
      large: (_, __) => const _AnimatedPhotoIndicator(),
    );
  }
}

class _AnimatedPhotoIndicator extends StatelessWidget {
  const _AnimatedPhotoIndicator({this.scale = 1.0});
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
        showLoadingIndicator: false,
      ),
    );
  }
}

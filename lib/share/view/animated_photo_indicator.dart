import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';
import 'package:platform_helper/platform_helper.dart';

class AnimatedPhotoIndicator extends StatelessWidget {
  AnimatedPhotoIndicator({
    Key? key,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    if (platformHelper.isMobile) {
      return const SizedBox(
        width: 104,
        height: 124,
        child: AnimatedSprite(
          sprites: Sprites(
            asset: 'photo_indicator_spritesheet_mobile.png',
            size: Size(250, 239),
            frames: 51,
            stepTime: 0.05,
          ),
        ),
      );
    } else {
      return const SizedBox(
        width: 136,
        height: 160,
        child: AnimatedSprite(
          sprites: Sprites(
            asset: 'photo_indicator_spritesheet_desktop.png',
            size: Size(173, 163),
            frames: 51,
            stepTime: 0.05,
          ),
        ),
      );
    }
  }
}

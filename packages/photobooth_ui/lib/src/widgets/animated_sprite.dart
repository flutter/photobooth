import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template sprites}
/// Object which contains meta data for a collection of sprites.
/// {@endtemplate}
class Sprites {
  /// {@macro sprites}
  const Sprites({
    required this.asset,
    required this.size,
    required this.frames,
    this.stepTime = 0.1,
  });

  /// The sprite sheet asset name.
  /// This should be the name of the file within
  /// the `assets/images` directory.
  final String asset;

  /// The size an individual sprite within the sprite sheet
  final Size size;

  /// The number of frames within the sprite sheet.
  final int frames;

  /// Number of seconds per frame. Defaults to 0.1.
  final double stepTime;
}

/// The animation mode which determines when the animation plays.
enum AnimationMode {
  /// Animations plays on a loop
  loop,

  /// Animations plays immediately once
  oneTime
}

/// {@template animated_sprite}
/// A widget which renders an animated sprite
/// given a collection of sprites.
/// {@endtemplate}
class AnimatedSprite extends StatefulWidget {
  /// {@macro animated_sprite}
  const AnimatedSprite({
    required this.sprites,
    this.mode = AnimationMode.loop,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor = PhotoboothColors.orange,
    super.key,
  });

  /// The collection of sprites which will be animated.
  final Sprites sprites;

  /// The mode of animation (`trigger`, `loop` or `oneTime`).
  final AnimationMode mode;

  /// Where should display a loading indicator while loading the sprite
  final bool showLoadingIndicator;

  /// Color for loading indicator
  final Color loadingIndicatorColor;

  @override
  State<AnimatedSprite> createState() => _AnimatedSpriteState();
}

enum _AnimatedSpriteStatus { loading, loaded, failure }

extension on _AnimatedSpriteStatus {
  /// Returns true for `_AnimatedSpriteStatus.loaded`.
  bool get isLoaded => this == _AnimatedSpriteStatus.loaded;
}

class _AnimatedSpriteState extends State<AnimatedSprite> {
  late SpriteSheet _spriteSheet;
  late SpriteAnimation _animation;
  Timer? _timer;
  var _status = _AnimatedSpriteStatus.loading;
  var _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadAnimation() async {
    try {
      _spriteSheet = SpriteSheet(
        image: await Flame.images.load(widget.sprites.asset),
        srcSize: Vector2(widget.sprites.size.width, widget.sprites.size.height),
      );
      _animation = _spriteSheet.createAnimation(
        row: 0,
        stepTime: widget.sprites.stepTime,
        to: widget.sprites.frames,
        loop: widget.mode == AnimationMode.loop,
      );

      setState(() {
        _status = _AnimatedSpriteStatus.loaded;
        if (widget.mode == AnimationMode.loop ||
            widget.mode == AnimationMode.oneTime) {
          _isPlaying = true;
        }
      });
    } catch (_) {
      setState(() => _status = _AnimatedSpriteStatus.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedCrossFade(
      firstChild: widget.showLoadingIndicator
          ? SizedBox.fromSize(
              size: const Size(20, 20),
              child: AppCircularProgressIndicator(
                strokeWidth: 2,
                color: widget.loadingIndicatorColor,
              ),
            )
          : const SizedBox(),
      secondChild: SizedBox.expand(
        child: _status.isLoaded
            ? SpriteAnimationWidget(animation: _animation, playing: _isPlaying)
            : const SizedBox(),
      ),
      crossFadeState: _status.isLoaded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}

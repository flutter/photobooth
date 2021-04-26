import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  /// Animation plays on interactions
  trigger,

  /// Animations plays on a loop
  loop
}

/// {@template animated_sprite}
/// A widget which renders an animated sprite
/// given a collection of sprites.
/// {@endtemplate}
class AnimatedSprite extends StatefulWidget {
  /// {@macro animated_sprite}
  const AnimatedSprite({
    Key? key,
    required this.sprites,
    this.mode = AnimationMode.loop,
  }) : super(key: key);

  /// The collection of sprites which will be animated.
  final Sprites sprites;

  /// The mode of animation (`trigger` or `loop`).
  final AnimationMode mode;

  @override
  _AnimatedSpriteState createState() => _AnimatedSpriteState();
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

  void _loadAnimation() async {
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
        if (widget.mode == AnimationMode.loop) {
          _isPlaying = true;
        }
      });
    } catch (_) {
      setState(() => _status = _AnimatedSpriteStatus.failure);
    }
  }

  void _onPressed() {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    _timer?.cancel();
    _timer = Timer(
      Duration(seconds: _animation.totalDuration().ceil()),
      () => setState(() => _isPlaying = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ConditionalIgnorePointer(
      condition: widget.mode == AnimationMode.loop,
      child: _ConditionalClickable(
        condition: widget.mode == AnimationMode.trigger,
        onPressed: _onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.sprites.size.height,
            maxWidth: widget.sprites.size.width,
          ),
          child: AspectRatio(
            aspectRatio: widget.sprites.size.width / widget.sprites.size.height,
            child: AnimatedOpacity(
              opacity: _status.isLoaded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _status.isLoaded
                  ? SpriteAnimationWidget(
                      animation: _animation,
                      playing: _isPlaying,
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionalIgnorePointer extends StatelessWidget {
  const _ConditionalIgnorePointer({
    Key? key,
    required this.condition,
    required this.child,
  }) : super(key: key);
  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return condition ? IgnorePointer(child: child) : child;
  }
}

class _ConditionalClickable extends StatelessWidget {
  const _ConditionalClickable({
    Key? key,
    required this.onPressed,
    required this.condition,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return condition
        ? Material(
            clipBehavior: Clip.hardEdge,
            shape: const StadiumBorder(),
            color: Colors.transparent,
            child: Ink(
              color: Colors.transparent,
              child: InkWell(
                mouseCursor: SystemMouseCursors.click,
                hoverColor: Colors.transparent,
                onTap: onPressed,
                child: child,
              ),
            ),
          )
        : child;
  }
}

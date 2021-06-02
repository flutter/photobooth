import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedPhotoboothPhoto extends StatefulWidget {
  const AnimatedPhotoboothPhoto({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CameraImage? image;

  @override
  _AnimatedPhotoboothPhotoState createState() =>
      _AnimatedPhotoboothPhotoState();
}

class _AnimatedPhotoboothPhotoState extends State<AnimatedPhotoboothPhoto> {
  late final Timer timer;
  var _isPhotoVisible = false;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _isPhotoVisible = true;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = context.select(
      (PhotoboothBloc bloc) => bloc.state.aspectRatio,
    );

    if (aspectRatio <= PhotoboothAspectRatio.portrait) {
      return AnimatedPhotoboothPhotoPortrait(
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      );
    } else {
      return AnimatedPhotoboothPhotoLandscape(
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      );
    }
  }
}

@visibleForTesting
class AnimatedPhotoboothPhotoLandscape extends StatelessWidget {
  const AnimatedPhotoboothPhotoLandscape({
    Key? key,
    required this.image,
    required this.isPhotoVisible,
  }) : super(key: key);

  final CameraImage? image;
  final bool isPhotoVisible;

  static const sprite = AnimatedSprite(
    mode: AnimationMode.oneTime,
    sprites: Sprites(
      asset: 'photo_frame_spritesheet_landscape.jpg',
      size: Size(1308, 1038),
      frames: 19,
      stepTime: 2 / 19,
    ),
    showLoadingIndicator: false,
  );
  static const aspectRatio = PhotoboothAspectRatio.landscape;
  static const left = 129.0;
  static const top = 88.0;
  static const right = 118.0;
  static const bottom = 154.0;

  @override
  Widget build(BuildContext context) {
    final smallPhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.33,
    );
    final mediumPhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.37,
    );
    final largePhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.5,
    );
    final xLargePhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.52,
    );

    return ResponsiveLayoutBuilder(
      small: (context, _) => smallPhoto,
      medium: (context, _) => mediumPhoto,
      large: (context, _) => largePhoto,
      xLarge: (context, _) => xLargePhoto,
    );
  }
}

@visibleForTesting
class AnimatedPhotoboothPhotoPortrait extends StatelessWidget {
  const AnimatedPhotoboothPhotoPortrait({
    Key? key,
    required this.image,
    required this.isPhotoVisible,
  }) : super(key: key);

  final CameraImage? image;
  final bool isPhotoVisible;

  static const sprite = AnimatedSprite(
    mode: AnimationMode.oneTime,
    sprites: Sprites(
      asset: 'photo_frame_spritesheet_portrait.png',
      size: Size(520, 698),
      frames: 38,
      stepTime: 0.05,
    ),
    showLoadingIndicator: false,
  );
  static const aspectRatio = PhotoboothAspectRatio.portrait;
  static const left = 93.0;
  static const top = 120.0;
  static const right = 79.0;
  static const bottom = 107.0;

  @override
  Widget build(BuildContext context) {
    final smallPhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.4,
    );
    final largePhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.8,
    );
    return ResponsiveLayoutBuilder(
      small: (context, _) => smallPhoto,
      large: (context, _) => largePhoto,
    );
  }
}

class _AnimatedPhotoboothPhoto extends StatelessWidget {
  const _AnimatedPhotoboothPhoto({
    Key? key,
    required this.sprite,
    required this.isPhotoVisible,
    required this.aspectRatio,
    required this.image,
    this.top = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.scale = 1.0,
  }) : super(key: key);

  final AnimatedSprite sprite;
  final bool isPhotoVisible;
  final double aspectRatio;
  final CameraImage? image;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final _image = image;
    return SizedBox(
      height: sprite.sprites.size.height * scale,
      width: sprite.sprites.size.width * scale,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(sprite.sprites.size),
              child: sprite,
            ),
          ),
          _image != null
              ? Positioned(
                  top: top * scale,
                  left: left * scale,
                  right: right * scale,
                  bottom: bottom * scale,
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: isPhotoVisible ? 1 : 0,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: PhotoboothPhoto(image: _image.data),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

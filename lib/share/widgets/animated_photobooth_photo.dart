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
        aspectRatio: aspectRatio,
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      );
    } else {
      return AnimatedPhotoboothPhotoLandscape(
        aspectRatio: aspectRatio,
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
    required this.aspectRatio,
    required this.image,
    required this.isPhotoVisible,
  }) : super(key: key);

  final double aspectRatio;
  final CameraImage? image;
  final bool isPhotoVisible;

  @override
  Widget build(BuildContext context) {
    final image = this.image;

    const sprite = AnimatedSprite(
      mode: AnimationMode.oneTime,
      sprites: Sprites(
        asset: 'photo_frame_spritesheet_landscape.png',
        size: Size(521, 420),
        frames: 28,
        stepTime: 0.05,
      ),
    );

    return ResponsiveLayoutBuilder(
      small: (context, _) => _AnimatedPhotoboothPhoto(
        aspectRatio: aspectRatio,
        image: image,
        isPhotoVisible: isPhotoVisible,
        containerHeight: 301,
        containerWidth: 420,
        sprite: sprite,
        padding: const EdgeInsets.only(
          left: 55,
          right: 47,
          bottom: 32,
        ),
      ),
      large: (context, _) => _AnimatedPhotoboothPhoto(
        aspectRatio: aspectRatio,
        image: image,
        isPhotoVisible: isPhotoVisible,
        containerHeight: 430,
        containerWidth: 600,
        sprite: sprite,
        padding: const EdgeInsets.only(
          left: 77,
          right: 68,
          bottom: 45,
        ),
      ),
      xLarge: (context, _) => _AnimatedPhotoboothPhoto(
        aspectRatio: aspectRatio,
        image: image,
        isPhotoVisible: isPhotoVisible,
        containerHeight: 688,
        containerWidth: 960,
        sprite: sprite,
        padding: const EdgeInsets.only(
          left: 122.0,
          right: 105.0,
          bottom: 82.0,
        ),
      ),
    );
  }
}

@visibleForTesting
class AnimatedPhotoboothPhotoPortrait extends StatelessWidget {
  const AnimatedPhotoboothPhotoPortrait({
    Key? key,
    required this.aspectRatio,
    required this.image,
    required this.isPhotoVisible,
  }) : super(key: key);

  final double aspectRatio;
  final CameraImage? image;
  final bool isPhotoVisible;

  @override
  Widget build(BuildContext context) {
    final image = this.image;

    const sprite = AnimatedSprite(
      mode: AnimationMode.oneTime,
      sprites: Sprites(
        asset: 'photo_frame_spritesheet_portrait.png',
        size: Size(520, 698),
        frames: 38,
        stepTime: 0.05,
      ),
    );

    return ResponsiveLayoutBuilder(
      small: (context, _) => _AnimatedPhotoboothPhoto(
        aspectRatio: aspectRatio,
        image: image,
        isPhotoVisible: isPhotoVisible,
        containerHeight: 330,
        containerWidth: 250,
        sprite: sprite,
        padding: const EdgeInsets.only(
          left: 43.0,
          right: 38.0,
          top: 5,
        ),
      ),
      large: (context, _) => _AnimatedPhotoboothPhoto(
        aspectRatio: aspectRatio,
        image: image,
        isPhotoVisible: isPhotoVisible,
        containerHeight: 660,
        containerWidth: 500,
        sprite: sprite,
        padding: const EdgeInsets.only(
          left: 85.0,
          right: 75.0,
          top: 10.0,
        ),
      ),
    );
  }
}

class _AnimatedPhotoboothPhoto extends StatelessWidget {
  const _AnimatedPhotoboothPhoto({
    Key? key,
    required this.containerHeight,
    required this.containerWidth,
    required this.sprite,
    required this.padding,
    required this.isPhotoVisible,
    required this.aspectRatio,
    required this.image,
  }) : super(key: key);

  final double containerHeight;
  final double containerWidth;
  final AnimatedSprite sprite;
  final EdgeInsetsGeometry padding;
  final bool isPhotoVisible;
  final double aspectRatio;
  final CameraImage? image;

  @override
  Widget build(BuildContext context) {
    final _image = image;
    return Container(
      height: containerHeight,
      width: containerWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: sprite,
          ),
          _image != null
              ? Center(
                  child: Padding(
                    padding: padding,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isPhotoVisible ? 1 : 0,
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: PhotoboothPhoto(image: _image.data),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

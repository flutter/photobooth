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
    return ResponsiveLayoutBuilder(
      small: (_, __) => AnimatedPhotoboothPhotoSmall(
        aspectRatio: aspectRatio,
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      ),
      large: (_, __) => AnimatedPhotoboothPhotoLarge(
        aspectRatio: aspectRatio,
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      ),
      xLarge: (_, __) => AnimatedPhotoboothPhotoXLarge(
        aspectRatio: aspectRatio,
        image: widget.image,
        isPhotoVisible: _isPhotoVisible,
      ),
    );
  }
}

@visibleForTesting
class AnimatedPhotoboothPhotoXLarge extends StatelessWidget {
  const AnimatedPhotoboothPhotoXLarge({
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
    return Container(
      height: 688,
      width: 960,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: AnimatedSprite(
              mode: AnimationMode.oneTime,
              sprites: Sprites(
                asset: 'photo_frame_spritesheet_desktop.png',
                size: Size(521, 420),
                frames: 28,
                stepTime: 0.05,
              ),
            ),
          ),
          image != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 122.0,
                      right: 105.0,
                      bottom: 82.0,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isPhotoVisible ? 1 : 0,
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: PhotoboothPhoto(image: image.data),
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

@visibleForTesting
class AnimatedPhotoboothPhotoLarge extends StatelessWidget {
  const AnimatedPhotoboothPhotoLarge({
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
    return Container(
      height: 430,
      width: 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(
            child: AnimatedSprite(
              mode: AnimationMode.oneTime,
              sprites: Sprites(
                asset: 'photo_frame_spritesheet_desktop.png',
                size: Size(521, 420),
                frames: 28,
                stepTime: 0.05,
              ),
            ),
          ),
          image != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 106.0,
                      right: 98.0,
                      bottom: 45.0,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isPhotoVisible ? 1 : 0,
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: PhotoboothPhoto(image: image.data),
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

@visibleForTesting
class AnimatedPhotoboothPhotoSmall extends StatelessWidget {
  const AnimatedPhotoboothPhotoSmall({
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
    return Container(
      height: 330,
      width: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(
            child: AnimatedSprite(
              mode: AnimationMode.oneTime,
              sprites: Sprites(
                asset: 'photo_frame_spritesheet_mobile.png',
                size: Size(520, 698),
                frames: 38,
                stepTime: 0.05,
              ),
            ),
          ),
          image != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 45.0,
                      right: 40.0,
                      top: 15.0,
                      bottom: 10.0,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isPhotoVisible ? 1 : 0,
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: PhotoboothPhoto(image: image.data),
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

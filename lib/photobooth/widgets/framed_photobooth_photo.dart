import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

const _mobileMargin = EdgeInsets.all(15);
const _mobilePadding = EdgeInsets.only(
  bottom: 30,
  left: 19,
  right: 10,
  top: 10,
);

const _desktopMargin = EdgeInsets.all(20);
const _desktopPadding = EdgeInsets.only(
  bottom: 30,
  left: 39,
  right: 19,
  top: 5,
);

/// A widget that displays [CharactersLayer] and [StickersLayer] on top of
/// the raw [image] took from the camera.
///
/// The [FramedPhotoboothPhoto] widget is styled to mimic a framed card photo.
class FramedPhotoboothPhoto extends StatelessWidget {
  const FramedPhotoboothPhoto({
    Key? key,
    required this.image,
    required this.aspectRatio,
    this.isTilted = true,
  }) : super(key: key);

  final double aspectRatio;
  final String image;
  final bool isTilted;

  @override
  Widget build(BuildContext context) {
    final isMobile = aspectRatio < 1;
    var photo = Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          margin: isMobile ? _mobileMargin : _desktopMargin,
          padding: isMobile ? _mobilePadding : _desktopPadding,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                isMobile
                    ? 'assets/images/photo_frame_mobile.png'
                    : 'assets/images/photo_frame.png',
              ),
            ),
          ),
          child: PhotoboothPhoto(image: image),
        ),
      ),
    );
    if (!isTilted) return photo;
    return Transform(
      alignment: const Alignment(0, -3 / 4),
      transform: Matrix4.identity()..rotateZ(-5 * (math.pi / 180)),
      child: photo,
    );
  }
}

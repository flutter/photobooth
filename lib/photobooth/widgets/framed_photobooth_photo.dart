import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// A widget that displays [CharactersLayer] and [StickersLayer] on top of
/// the raw [image] took from the camera.
///
/// The [FramedPhotoboothPhoto] widget is styled to mimic a framed card photo.
class FramedPhotoboothPhoto extends StatelessWidget {
  const FramedPhotoboothPhoto({
    Key? key,
    required this.image,
    this.isTilted = true,
  }) : super(key: key);

  final Uint8List image;
  final bool isTilted;

  @override
  Widget build(BuildContext context) {
    var photo = Center(
      child: AspectRatio(
        aspectRatio: isMobile ? 3 / 4 : 4 / 3,
        child: Container(
          margin:
              isMobile ? const EdgeInsets.all(15) : const EdgeInsets.all(20),
          padding: isMobile
              ? const EdgeInsets.only(
                  bottom: 30,
                  left: 19,
                  right: 10,
                  top: 10,
                )
              : const EdgeInsets.only(
                  bottom: 30,
                  left: 39,
                  right: 19,
                  top: 5,
                ),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(isMobile
                  ? 'assets/images/photo_frame_mobile.png'
                  : 'assets/images/photo_frame.png'),
            ),
          ),
          child: PhotoboothPhoto(
            image: image,
          ),
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

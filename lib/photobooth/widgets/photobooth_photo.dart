import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// A widget that displays [CharactersLayer] and [StickersLayer] on top of
/// the raw [image] took from the camera.
///
/// The [PhotoboothPhoto] widget is styled to mimic a physical card photo.
class PhotoboothPhoto extends StatelessWidget {
  const PhotoboothPhoto({
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
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: PhotoboothColors.black.withOpacity(
                  0.72,
                ),
                offset: const Offset(-6, 1),
                blurRadius: 8.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PreviewImage(data: image),
              const CharactersLayer(),
              const StickersLayer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PhotoboothColors.white,
                    width: 8,
                  ),
                ),
              )
            ],
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

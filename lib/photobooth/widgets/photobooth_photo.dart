import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// A widget that displays [CharactersLayer] and [StickersLayer] on top of
/// the raw [image] took from the camera.
class PhotoboothPhoto extends StatelessWidget {
  const PhotoboothPhoto({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PreviewImage(data: image),
        const CharactersLayer(),
        const StickersLayer(),
      ],
    );
  }
}

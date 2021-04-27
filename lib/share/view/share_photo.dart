import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePhoto extends StatelessWidget {
  const SharePhoto({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CameraImage? image;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    return Container(
      height: isMobile ? 330 : 430,
      width: isMobile ? 250 : 600,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(isMobile
              ? 'assets/images/photo_placeholder_mobile.png'
              : 'assets/images/photo_placeholder_desktop.png'),
        ),
      ),
      child: image != null
          ? PhotoboothPhoto(image: image.data, isTilted: false)
          : const SizedBox(),
    );
  }
}

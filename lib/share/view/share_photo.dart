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
    return ResponsiveLayoutBuilder(
      desktop: (_) => Container(
        height: 400,
        padding: const EdgeInsets.symmetric(
          vertical: 35,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/photo_placeholder_desktop.png'),
          ),
        ),
        child: image != null
            ? PhotoboothPhoto(
                image: image!.data,
                shouldTransform: false,
              )
            : const SizedBox(),
      ),
      mobile: (_) => Container(
        height: 400,
        padding: const EdgeInsets.symmetric(
          vertical: 35,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/photo_placeholder_mobile.png'),
          ),
        ),
        child: image != null
            ? PhotoboothPhoto(
                image: image!.data,
                shouldTransform: false,
              )
            : const SizedBox(),
      ),
    );
  }
}

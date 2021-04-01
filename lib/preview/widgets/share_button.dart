import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/preview/preview.dart';

//TODO: move to package
class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);

  final CameraImage cameraImage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 208,
        height: 54,
      ),
      child: ElevatedButton(
        child: Text(l10n.previewPageShareButtonText),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ShareDialog(
              cameraImage: cameraImage,
            ),
          );
        },
      ),
    );
  }
}
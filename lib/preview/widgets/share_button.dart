import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
      ),
      child: ElevatedButton(
        child: Text(l10n.previewPageShareButtonText),
        onPressed: () {
          showDialog(
            barrierColor: PhotoboothColors.gray.withOpacity(0.75),
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

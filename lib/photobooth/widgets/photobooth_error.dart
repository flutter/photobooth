import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({Key? key, required this.error}) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error.toLocalizedError(context)));
  }
}

extension on CameraException {
  String toLocalizedError(BuildContext context) {
    final l10n = context.l10n;
    if (this is CameraNotAllowedException) {
      return l10n.previewPageCameraNotAllowedText;
    }
    return description;
  }
}

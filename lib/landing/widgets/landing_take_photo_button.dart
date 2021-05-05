import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class LandingTakePhotoButton extends StatelessWidget {
  const LandingTakePhotoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(PhotoboothPage.route()),
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}

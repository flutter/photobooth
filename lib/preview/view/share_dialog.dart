import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/preview/preview.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);

  final CameraImage cameraImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 168,
          vertical: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PreviewImage(
              image: cameraImage,
              height: 200,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.shareDialogHeading,
              style: theme.textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.shareDialogSubheading,
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const TwitterButton(),
            const SizedBox(height: 15),
            const FacebookButton(),
          ],
        ),
      ),
    );
  }
}

class TwitterButton extends StatelessWidget {
  const TwitterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 208,
        height: 50,
      ),
      child: ElevatedButton(
        child: Text(l10n.shareDialogTwitterButtonText),
        onPressed: () => print(''),
      ),
    );
  }
}

class FacebookButton extends StatelessWidget {
  const FacebookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 208,
        height: 50,
      ),
      child: ElevatedButton(
        child: Text(l10n.shareDialogFacebookButtonText),
        onPressed: () => print(''),
      ),
    );
  }
}

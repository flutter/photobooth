import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Dialog(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PreviewImage(data: image.data, height: 200),
                  const SizedBox(height: 12),
                  Text(
                    l10n.shareDialogHeading,
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.shareDialogSubheading,
                    style: theme.textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      const TwitterButton(),
                      const FacebookButton(),
                    ],
                  ),
                  const SizedBox(height: 68),
                  Text(
                    l10n.shareDialogDeleteText,
                    style: theme.textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 15,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class TwitterButton extends StatelessWidget {
  const TwitterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {},
      child: Text(l10n.shareDialogTwitterButtonText),
    );
  }
}

class FacebookButton extends StatelessWidget {
  const FacebookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {},
      child: Text(l10n.shareDialogFacebookButtonText),
    );
  }
}

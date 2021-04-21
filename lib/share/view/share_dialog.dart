import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
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
    final borderRadius = BorderRadius.circular(12);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhotoboothColors.whiteBackground,
                PhotoboothColors.white,
              ],
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: 900,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 60,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 300,
                          child: PhotoboothPhoto(image: image.data),
                        ),
                        const SizedBox(height: 60),
                        Text(
                          l10n.shareDialogHeading,
                          style: theme.textTheme.headline1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.shareDialogSubheading,
                          style: theme.textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 42),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TwitterButton(),
                            const SizedBox(width: 36),
                            const FacebookButton(),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 24,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: PhotoboothColors.black.withOpacity(0.54),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
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

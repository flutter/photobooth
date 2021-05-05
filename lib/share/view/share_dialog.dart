import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    Key? key,
    required this.aspectRatio,
    required this.image,
  }) : super(key: key);

  final double aspectRatio;
  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Container(
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
                      height: 430,
                      width: 600,
                      child: FramedPhotoboothPhoto(
                        aspectRatio: aspectRatio,
                        image: image.data,
                      ),
                    ),
                    const SizedBox(height: 60),
                    SelectableText(
                      l10n.shareDialogHeading,
                      key: const Key('shareDialog_heading'),
                      style: theme.textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SelectableText(
                      l10n.shareDialogSubheading,
                      key: const Key('shareDialog_subheading'),
                      style: theme.textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TwitterButton(),
                        const SizedBox(width: 36),
                        const FacebookButton(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const SocialMediaShareClarificationNote(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 24,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: PhotoboothColors.black54,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

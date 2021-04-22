import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58.0),
                  child: PhotoboothPhoto(image: image.data),
                ),
                const SizedBox(height: 60),
                Text(
                  l10n.shareDialogHeading,
                  key: const Key('shareBottomSheet_heading'),
                  style: theme.textTheme.headline1?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.shareDialogSubheading,
                  key: const Key('shareBottomSheet_subheading'),
                  style: theme.textTheme.headline2?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 42),
                Column(
                  children: [
                    const TwitterButton(),
                    const SizedBox(height: 18),
                    const FacebookButton(),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Positioned(
          right: 24,
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
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({
    required this.image,
    super.key,
  });

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
        color: PhotoboothColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 60),
                  SharePreviewPhoto(image: image),
                  const SizedBox(height: 60),
                  SelectableText(
                    l10n.shareDialogHeading,
                    key: const Key('shareBottomSheet_heading'),
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SelectableText(
                    l10n.shareDialogSubheading,
                    key: const Key('shareBottomSheet_subheading'),
                    style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 42),
                  const Column(
                    children: [
                      TwitterButton(),
                      SizedBox(height: 18),
                      FacebookButton(),
                    ],
                  ),
                  const SizedBox(height: 42),
                  const SocialMediaShareClarificationNote(),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothPlaceholder extends StatelessWidget {
  const PhotoboothPlaceholder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return AppPageView(
      background: const PermissionsBackground(),
      body: Column(
        children: [
          const SizedBox(height: 200),
          Text(
            l10n.photoBoothPlaceholderHeadline,
            style: theme.textTheme.headline1?.copyWith(
              color: PhotoboothColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.photoBoothPlaceholderSubheadline,
            style: theme.textTheme.headline2?.copyWith(
              color: PhotoboothColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      footer: const WhiteFooter(),
    );
  }
}

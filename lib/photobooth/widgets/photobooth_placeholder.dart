import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothPlaceholder extends StatelessWidget {
  const PhotoboothPlaceholder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          ),
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: WhiteFooter(),
        ),
      ],
    );
  }
}

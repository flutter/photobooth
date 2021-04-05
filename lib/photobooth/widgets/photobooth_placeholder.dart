import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class PhotoboothPlaceholder extends StatelessWidget {
  const PhotoboothPlaceholder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.photoBothPlaceholderHeadline,
              style: theme.textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.photoBothPlaceholderSubheadline,
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

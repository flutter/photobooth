import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';

class ClearStickersDialog extends StatelessWidget {
  const ClearStickersDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 80,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.clearStickersDialogHeading,
              key: const Key('clearStickersDialog_heading'),
              style: theme.textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.clearStickersDialogSubheading,
              key: const Key('clearStickersDialog_subheading'),
              style: theme.textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 30,
              runSpacing: 15,
              children: const [
                ClearStickersCancelButton(),
                ClearStickersConfirmButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

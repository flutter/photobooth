import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareSuccessCaption extends StatelessWidget {
  const ShareSuccessCaption({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SelectableText.rich(
      TextSpan(
        style: theme.textTheme.bodySmall?.copyWith(
          color: PhotoboothColors.white,
        ),
        children: <TextSpan>[
          TextSpan(text: l10n.sharePageSuccessCaption1),
          TextSpan(
            text: l10n.sharePageSuccessCaption2,
            recognizer: TapGestureRecognizer()..onTap = launchPhotoboothEmail,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: l10n.sharePageSuccessCaption3),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

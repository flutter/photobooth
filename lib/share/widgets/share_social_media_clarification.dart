import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SocialMediaShareClarificationNote extends StatelessWidget {
  const SocialMediaShareClarificationNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SelectableText.rich(
      TextSpan(
        style: theme.textTheme.bodySmall?.copyWith(
          color: PhotoboothColors.black,
          fontWeight: PhotoboothFontWeight.regular,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.sharePageSocialMediaShareClarification1,
          ),
          TextSpan(
            text: l10n.sharePageSocialMediaShareClarification2,
            recognizer: TapGestureRecognizer()..onTap = launchPhotoboothEmail,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: l10n.sharePageSocialMediaShareClarification3,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

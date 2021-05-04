import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SocialMediaShareClarificationNote extends StatelessWidget {
  const SocialMediaShareClarificationNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Text(
      l10n.sharePageSocialMediaShareClarification,
      textAlign: TextAlign.center,
      style: theme.textTheme.caption?.copyWith(
        color: PhotoboothColors.black,
        fontWeight: PhotoboothFontWeight.regular,
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class LearnMoreAboutText extends StatelessWidget {
  const LearnMoreAboutText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SelectableText.rich(
      TextSpan(
        text: l10n.sharePageLearnMoreAboutTextPart1,
        style: theme.textTheme.bodyText1?.copyWith(
          fontWeight: PhotoboothFontWeight.regular,
          color: PhotoboothColors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.footerMadeWithFlutterLinkText,
            recognizer: TapGestureRecognizer()..onTap = launchFlutterDevLink,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart2,
          ),
          TextSpan(
            text: l10n.footerMadeWithFirebaseLinkText,
            recognizer: TapGestureRecognizer()..onTap = launchFirebaseLink,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart3,
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart4,
            recognizer: TapGestureRecognizer()..onTap = () => openLink(''),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

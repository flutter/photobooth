import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class LearnMoreAboutText extends StatelessWidget {
  const LearnMoreAboutText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: l10n.sharePageLearnMoreAboutTextPart1,
        style: theme.textTheme.bodyText1?.copyWith(
          fontWeight: PhotoboothFontWeight.regular,
          color: PhotoboothColors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.footerMadeWithFlutterLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink('https://flutter.dev'),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart2,
          ),
          TextSpan(
            text: l10n.footerMadeWithFirebaseLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink('https://firebase.google.com'),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart3,
          ),
          TextSpan(
            text: l10n.footerMadeWithFirebaseLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink('https://firebase.google.com'),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

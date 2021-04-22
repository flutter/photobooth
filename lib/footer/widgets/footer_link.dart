import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

/// {@template link_text}
/// Displays a [text] and navigates to the [link] upon click
/// {@endtemplate}
class FooterLink extends StatelessWidget {
  /// {@macro link_text}
  const FooterLink({
    Key? key,
    required this.text,
    required this.link,
  }) : super(key: key);

  /// Text to display
  final String text;

  /// Link to navigate
  final String link;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: () => openLink(link),
      child: Text(text),
    );
  }
}

class FooterMadeWithLink extends StatelessWidget {
  const FooterMadeWithLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: l10n.footerMadeWithText,
        style: theme.textTheme.bodyText1?.copyWith(
          fontWeight: PhotoboothFontWeight.regular,
          color: defaultTextStyle.style.color,
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
          const TextSpan(
            text: ' & ',
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

class FooterGoogleIOLink extends StatelessWidget {
  const FooterGoogleIOLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: '',
      text: l10n.footerGoogleIOLinkText,
    );
  }
}

class FooterCodelabLink extends StatelessWidget {
  const FooterCodelabLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link:
          'https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0',
      text: l10n.footerCodelabLinkText,
    );
  }
}

class FooterHowItsMadeLink extends StatelessWidget {
  const FooterHowItsMadeLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: '',
      text: l10n.footerHowItsMadeLinkText,
    );
  }
}

class FooterTermsOfServiceLink extends StatelessWidget {
  const FooterTermsOfServiceLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://policies.google.com/terms',
      text: l10n.footerTermsOfServiceLinkText,
    );
  }
}

class FooterPrivacyPolicyLink extends StatelessWidget {
  const FooterPrivacyPolicyLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://policies.google.com/privacy',
      text: l10n.footerPrivacyPolicyLinkText,
    );
  }
}

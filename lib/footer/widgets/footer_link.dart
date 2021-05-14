import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class FooterLink extends StatelessWidget {
  const FooterLink({
    Key? key,
    required this.text,
    required this.link,
  }) : super(key: key);

  final String text;
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
            recognizer: TapGestureRecognizer()..onTap = launchFlutterDevLink,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(
            text: ' & ',
          ),
          TextSpan(
            text: l10n.footerMadeWithFirebaseLinkText,
            recognizer: TapGestureRecognizer()..onTap = launchFirebaseLink,
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
      link: googleIOExternalLink,
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
      link:
          'https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883',
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

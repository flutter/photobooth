import 'package:flutter/material.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class WhiteFooter extends StatelessWidget {
  const WhiteFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Footer(
      textColor: PhotoboothColors.white,
    );
  }
}

class BlackFooter extends StatelessWidget {
  const BlackFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Footer(
      textColor: PhotoboothColors.black,
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.textColor}) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: textColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 32),
        child: AdaptiveBuilder(
          builder: (context, breakpoint) {
            if (breakpoint == WindowBreakpoint.small) {
              return _ColumnFooter(key: const Key('footer_column'));
            }
            return _RowFooter(key: const Key('footer_row'));
          },
        ),
      ),
    );
  }
}

class _ColumnFooter extends StatelessWidget {
  _ColumnFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 8);
    return Column(
      children: [
        const FooterMadeWithLink(),
        const SizedBox(height: 32),
        const FooterGoogleIOLink(),
        gap,
        const FooterCodelabLink(),
        gap,
        const FooterHowItsMadeLink(),
        gap,
        const FooterTermsOfServiceLink(),
        gap,
        const FooterPrivacyPolicyLink(),
      ],
    );
  }
}

class _RowFooter extends StatelessWidget {
  _RowFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      width: 32,
    );
    return Row(
      children: [
        const FooterMadeWithLink(),
        const Spacer(),
        const FooterGoogleIOLink(),
        gap,
        const FooterCodelabLink(),
        gap,
        const FooterHowItsMadeLink(),
        gap,
        const FooterTermsOfServiceLink(),
        gap,
        const FooterPrivacyPolicyLink(),
      ],
    );
  }
}

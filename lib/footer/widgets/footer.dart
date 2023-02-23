import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class WhiteFooter extends StatelessWidget {
  const WhiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Footer(textColor: PhotoboothColors.white);
  }
}

class BlackFooter extends StatelessWidget {
  const BlackFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Footer(textColor: PhotoboothColors.black);
  }
}

class Footer extends StatelessWidget {
  const Footer({required this.textColor, super.key});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 32),
        child: ResponsiveLayoutBuilder(
          small: (_, __) => const _ColumnFooter(key: Key('footer_column')),
          large: (_, __) => const _RowFooter(key: Key('footer_row')),
        ),
      ),
    );
  }
}

class _ColumnFooter extends StatelessWidget {
  const _ColumnFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FooterMadeWithLink(),
        SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 16,
          children: [
            FooterGoogleIOLink(),
            SizedBox(width: 30),
            FooterCodelabLink(),
            SizedBox(width: 30),
            FooterHowItsMadeLink(),
          ],
        ),
        gap,
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 16,
          children: [
            FooterTermsOfServiceLink(),
            SizedBox(width: 30),
            FooterPrivacyPolicyLink(),
          ],
        ),
      ],
    );
  }
}

class _RowFooter extends StatelessWidget {
  const _RowFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 32);
    return const Row(
      children: [
        FooterMadeWithLink(),
        Spacer(),
        FooterGoogleIOLink(),
        gap,
        FooterCodelabLink(),
        gap,
        FooterHowItsMadeLink(),
        gap,
        FooterTermsOfServiceLink(),
        gap,
        FooterPrivacyPolicyLink(),
      ],
    );
  }
}

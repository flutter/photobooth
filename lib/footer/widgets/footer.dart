import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class WhiteFooter extends StatelessWidget {
  const WhiteFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Footer(textColor: PhotoboothColors.white);
  }
}

class BlackFooter extends StatelessWidget {
  const BlackFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Footer(textColor: PhotoboothColors.black);
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.textColor}) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.caption!.copyWith(color: textColor),
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
  const _ColumnFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FooterMadeWithLink(),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 16,
          children: const [
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
          children: const [
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
  const _RowFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 32);
    return Row(
      children: const [
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

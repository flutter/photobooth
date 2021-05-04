// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('WhiteFooter', () {
    testWidgets('renders Footer with white text color', (tester) async {
      await tester.pumpApp(WhiteFooter());
      final footer = tester.widget<Footer>(find.byType(Footer));
      expect(footer.textColor, PhotoboothColors.white);
    });
  });

  group('BlackFooter', () {
    testWidgets('renders Footer with black text color', (tester) async {
      await tester.pumpApp(BlackFooter());
      final footer = tester.widget<Footer>(find.byType(Footer));
      expect(footer.textColor, PhotoboothColors.black);
    });
  });

  group('Footer', () {
    testWidgets('renders column when screen is small', (tester) async {
      tester.setDisplaySize(const Size(320, 800));
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byKey(const Key('footer_column')), findsOneWidget);
    });

    testWidgets('renders row when screen is big', (tester) async {
      tester.setDisplaySize(const Size(1920, 1080));
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byKey(const Key('footer_row')), findsOneWidget);
    });

    testWidgets('renders FooterGoogleIOLink widget', (tester) async {
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byType(FooterGoogleIOLink), findsOneWidget);
    });

    testWidgets('renders FooterCodelabLink widget', (tester) async {
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byType(FooterCodelabLink), findsOneWidget);
    });

    testWidgets('renders FooterHowItsMadeLink widget', (tester) async {
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byType(FooterHowItsMadeLink), findsOneWidget);
    });

    testWidgets('renders FooterTermsOfServiceLink widget', (tester) async {
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byType(FooterTermsOfServiceLink), findsOneWidget);
    });

    testWidgets('renders FooterPrivacyPolicyLink widget', (tester) async {
      await tester.pumpApp(Footer(textColor: PhotoboothColors.black));
      expect(find.byType(FooterPrivacyPolicyLink), findsOneWidget);
    });
  });
}

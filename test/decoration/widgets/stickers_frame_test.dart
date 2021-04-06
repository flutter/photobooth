// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import '../../helpers/helpers.dart';

void main() {
  group('StickersFrame', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(Material(
        child: StickersFrame(),
      ));
      expect(find.byType(StickersFrame), findsOneWidget);
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(Material(
        child: StickersFrame(),
      ));
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets(
        'when clicks on OpenStickersButton then StickersCarousel displays',
        (tester) async {
      await tester.pumpApp(Material(
        child: StickersFrame(),
      ));
      final stickersButton = find.byType(OpenStickersButton);
      final stickersCarousel = find.byType(StickersCarousel);
      expect(stickersButton, findsOneWidget);
      expect(stickersCarousel, findsNothing);
      await tester.ensureVisible(stickersButton);
      await tester.tap(stickersButton);
      await tester.pumpAndSettle();
      await tester.pump();
      expect(stickersCarousel, findsOneWidget);
    });
  });
}

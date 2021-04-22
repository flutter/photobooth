// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareErrorBottomSheet', () {
    testWidgets('displays heading', (tester) async {
      await tester.pumpApp(Scaffold(body: ShareErrorBottomSheet()));
      expect(find.byKey(Key('shareErrorBottomSheet_heading')), findsOneWidget);
    });

    testWidgets('displays subheading', (tester) async {
      await tester.pumpApp(Scaffold(body: ShareErrorBottomSheet()));
      expect(
          find.byKey(Key('shareErrorBottomSheet_subheading')), findsOneWidget);
    });

    testWidgets('displays a ShareTryAgainButton button', (tester) async {
      await tester.pumpApp(Scaffold(body: ShareErrorBottomSheet()));
      expect(find.byType(ShareTryAgainButton), findsOneWidget);
    });

    testWidgets('pops when tapped on ShareTryAgainButton button',
        (tester) async {
      await tester.pumpApp(Scaffold(body: ShareErrorBottomSheet()));
      await tester.ensureVisible(find.byType(ShareTryAgainButton));
      await tester.tap(find.byType(ShareTryAgainButton));
      await tester.pumpAndSettle();
      expect(find.byType(ShareErrorBottomSheet), findsNothing);
    });

    testWidgets('pops when tapped on close button', (tester) async {
      await tester.pumpApp(Scaffold(body: ShareErrorBottomSheet()));
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareErrorBottomSheet), findsNothing);
    });
  });
}

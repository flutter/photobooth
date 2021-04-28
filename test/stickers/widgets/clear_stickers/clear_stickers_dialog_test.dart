// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import '../../../helpers/helpers.dart';

void main() {
  group('ClearStickersDialog', () {
    testWidgets('renders heading', (tester) async {
      await tester.pumpApp(ClearStickersDialog());
      expect(find.byKey(Key('clearStickersDialog_heading')), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(ClearStickersDialog());
      expect(find.byKey(Key('clearStickersDialog_subheading')), findsOneWidget);
    });

    testWidgets('tapping on ClearStickersCancelButton will dismiss the dialog',
        (tester) async {
      await tester.pumpApp(ClearStickersDialog());
      await tester.ensureVisible(find.byType(ClearStickersCancelButton));
      await tester.tap(find.byType(ClearStickersCancelButton));
      await tester.pumpAndSettle();
      expect(find.byType(ClearStickersDialog), findsNothing);
    });

    testWidgets('tapping on ClearStickersConfirmButton will dismiss the dialog',
        (tester) async {
      await tester.pumpApp(ClearStickersDialog());
      await tester.ensureVisible(find.byType(ClearStickersConfirmButton));
      await tester.tap(find.byType(ClearStickersConfirmButton));
      await tester.pumpAndSettle();
      expect(find.byType(ClearStickersDialog), findsNothing);
    });
  });
}

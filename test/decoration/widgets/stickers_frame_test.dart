// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import '../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

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

    /*testWidgets(
        'when clicks on OpenStickersButton then StickersCarousel displays',
        (tester) async {
      await tester.pumpApp(Scaffold(
        body: StickersFrame(),
      ));
      expect(find.byType(StickersCarousel), findsNothing);
      await tester.ensureVisible(find.byType(OpenStickersButton));
      await tester.tap(find.byType(OpenStickersButton));
      await tester.pumpAndSettle();
      expect(find.byType(StickersCarousel), findsOneWidget);
    });*/
  });
}

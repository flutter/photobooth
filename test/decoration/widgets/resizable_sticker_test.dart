// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import '../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  group('ResizebleSticker', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(find.byType(ResizebleSticker), findsOneWidget);
    });

    testWidgets('has image as draggable point', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_image_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('has top left corner as draggable point', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_topLeft_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('has top right corner as draggable point', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_topRight_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('has bottom right corner as draggable point', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_bottomRight_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('has bottom left corner as draggable point', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_bottomLeft_draggablePoint'),
          ),
          findsOneWidget);
    });
  });
}

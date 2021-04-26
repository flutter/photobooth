// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class MockImages extends Mock implements Images {}

class MockImage extends Mock implements ui.Image {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final image = await decodeImageFromList(Uint8List.fromList(transparentImage));
  group('AnimatedSprite', () {
    late Images images;

    setUp(() {
      images = MockImages();
      Flame.images = images;
    });

    testWidgets('renders SizedBox when loading asset', (tester) async {
      await tester.pumpWidget(AnimatedSprite(
        sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
      ));
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (loop)',
        (tester) async {
      await tester.runAsync(() async {
        final images = MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AnimatedSprite(
              sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
              mode: AnimationMode.loop,
            ),
          ),
        ));
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (trigger)',
        (tester) async {
      await tester.runAsync(() async {
        when(() => images.load(any())).thenAnswer((_) async => image);
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AnimatedSprite(
              sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
              mode: AnimationMode.trigger,
            ),
          ),
        ));
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isFalse);
      });
    });

    testWidgets('tapping on trigger SpriteAnimationWidget starts playing',
        (tester) async {
      await tester.runAsync(() async {
        when(() => images.load(any())).thenAnswer((_) async => image);
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AnimatedSprite(
              sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
              mode: AnimationMode.trigger,
            ),
          ),
        ));
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        await tester.tap(spriteAnimationFinder);
        await tester.pump();
        var widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
        await Future.delayed(Duration(seconds: 1));
        await tester.pumpAndSettle();
        widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isFalse);
      });
    });
  });
}

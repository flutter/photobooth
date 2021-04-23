// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = CameraImage(width: width, height: height, data: data);

  late PhotoboothBloc photoboothBloc;
  group('StickersLayer', () {
    setUpAll(() {
      registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
      registerFallbackValue<PhotoboothState>(FakePhotoboothState());
    });

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
    });

    testWidgets('displays selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(id: '0', asset: Assets.android)],
          stickers: [PhotoAsset(id: '0', asset: Assets.banana)],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_0_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('displays multiple selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(id: '0', asset: Assets.android)],
          stickers: [
            PhotoAsset(id: '0', asset: Assets.banana),
            PhotoAsset(id: '1', asset: Assets.banana),
            PhotoAsset(id: '2', asset: Assets.beret),
          ],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_0_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_1_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_beret_2_positioned')),
        findsOneWidget,
      );
    });
  });
}

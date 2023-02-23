// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  late PhotoboothBloc photoboothBloc;
  group('StickersLayer', () {
    setUpAll(() {
      registerFallbackValue(FakePhotoboothEvent());
      registerFallbackValue(FakePhotoboothState());
    });

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
    });

    testWidgets('displays selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_01_google_v1_0_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('displays multiple selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
          stickers: [
            PhotoAsset(id: '0', asset: Assets.props.first),
            PhotoAsset(id: '1', asset: Assets.props.first),
            PhotoAsset(id: '2', asset: Assets.props.last),
          ],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_01_google_v1_0_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_01_google_v1_1_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_25_shapes_v1_2_positioned')),
        findsOneWidget,
      );
    });
  });
}

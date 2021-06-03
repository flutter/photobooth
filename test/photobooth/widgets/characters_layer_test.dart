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
  group('CharactersLayer', () {
    setUpAll(() {
      registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
      registerFallbackValue<PhotoboothState>(FakePhotoboothState());
    });

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
    });

    testWidgets('renders Android character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_android_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Dash character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_dash_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Sparky character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.sparky)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_sparky_positioned')),
        findsOneWidget,
      );
    });
  });
}

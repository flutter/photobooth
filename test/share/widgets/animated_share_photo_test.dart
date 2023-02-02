// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  late PhotoboothBloc photoboothBloc;

  setUpAll(() {
    registerFallbackValue(FakePhotoboothEvent());
    registerFallbackValue(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('AnimatedPhotoboothPhoto', () {
    group('portrait', () {
      testWidgets(
          'displays AnimatedPhotoboothPhotoPortrait '
          'when aspect ratio is portrait '
          'and screen size is small', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
            aspectRatio: PhotoboothAspectRatio.portrait,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoPortrait),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoPortrait '
          'when aspect ratio is portrait '
          'and screen size is large', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
            aspectRatio: PhotoboothAspectRatio.portrait,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoPortrait),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoPortrait '
          'when aspect ratio is portrait '
          'and screen size is xLarge', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
            aspectRatio: PhotoboothAspectRatio.portrait,
          ),
        );
        tester.setDisplaySize(
          const Size(
            PhotoboothBreakpoints.large + 100,
            800,
          ),
        );

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoPortrait),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoPortrait '
          'when aspect ratio is portrait '
          'with isPhotoVisible false', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
            aspectRatio: PhotoboothAspectRatio.portrait,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoPortrait>(
          find.byType(AnimatedPhotoboothPhotoPortrait),
        );
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoPortrait '
          'when aspect ratio is portrait '
          'with isPhotoVisible true '
          'after 2 seconds', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
            aspectRatio: PhotoboothAspectRatio.portrait,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoPortrait>(
          find.byType(AnimatedPhotoboothPhotoPortrait),
        );
        expect(widget.isPhotoVisible, true);
      });
    });

    group('landscape', () {
      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'and screen size is small', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoLandscape),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'and screen size is medium', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.medium, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoLandscape),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'and screen size is large', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoLandscape),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'and screen size is xLarge', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(
          const Size(
            PhotoboothBreakpoints.large + 100,
            800,
          ),
        );

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(
          find.byType(AnimatedPhotoboothPhotoLandscape),
          findsOneWidget,
        );
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'with isPhotoVisible false', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoLandscape>(
          find.byType(AnimatedPhotoboothPhotoLandscape),
        );
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLandscape '
          'when aspect ratio is landscape '
          'with isPhotoVisible true '
          'after 2 seconds', (tester) async {
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(
            image: image,
          ),
        );
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoLandscape>(
          find.byType(AnimatedPhotoboothPhotoLandscape),
        );
        expect(widget.isPhotoVisible, true);
      });
    });
  });
}

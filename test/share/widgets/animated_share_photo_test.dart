// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:camera/camera.dart';
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
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('AnimatedPhotoboothPhoto', () {
    group('small', () {
      testWidgets('displays AnimatedPhotoboothPhotoSmall', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoSmall), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoSmall '
          'with isPhotoVisible false', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoSmall>(
            find.byType(AnimatedPhotoboothPhotoSmall));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoSmall '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoSmall>(
            find.byType(AnimatedPhotoboothPhotoSmall));
        expect(widget.isPhotoVisible, true);
      });
    });

    group('large', () {
      testWidgets('displays AnimatedPhotoboothPhotoLarge', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoLarge), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLarge '
          'with isPhotoVisible false', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoLarge>(
            find.byType(AnimatedPhotoboothPhotoLarge));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoLarge '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoLarge>(
            find.byType(AnimatedPhotoboothPhotoLarge));
        expect(widget.isPhotoVisible, true);
      });
    });

    group('xLarge', () {
      testWidgets('displays AnimatedPhotoboothPhotoXLarge', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoXLarge), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoXLarge '
          'with isPhotoVisible false', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoXLarge>(
            find.byType(AnimatedPhotoboothPhotoXLarge));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoXLarge '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoXLarge>(
            find.byType(AnimatedPhotoboothPhotoXLarge));
        expect(widget.isPhotoVisible, true);
      });
    });
  });
}

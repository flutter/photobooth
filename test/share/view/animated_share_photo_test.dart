// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }
}

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
    group('mobile', () {
      testWidgets('displays AnimatedPhotoboothPhotoMobile', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoMobile), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoMobile '
          'with isPhotoVisible false', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoMobile>(
            find.byType(AnimatedPhotoboothPhotoMobile));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoMobile '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester.setDisplaySize(const Size(320, 800));
        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoMobile>(
            find.byType(AnimatedPhotoboothPhotoMobile));
        expect(widget.isPhotoVisible, true);
      });
    });

    group('desktop', () {
      testWidgets('displays AnimatedPhotoboothPhotoDesktop', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoDesktop), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoDesktop '
          'with isPhotoVisible false', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoDesktop>(
            find.byType(AnimatedPhotoboothPhotoDesktop));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoDesktop '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoDesktop>(
            find.byType(AnimatedPhotoboothPhotoDesktop));
        expect(widget.isPhotoVisible, true);
      });
    });

    group('wide desktop', () {
      testWidgets('displays AnimatedPhotoboothPhotoWideDesktop',
          (tester) async {
        tester
            .setDisplaySize(const Size(PhotoboothBreakpoints.desktop + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(AnimatedPhotoboothPhotoWideDesktop), findsOneWidget);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoWideDesktop '
          'with isPhotoVisible false', (tester) async {
        tester
            .setDisplaySize(const Size(PhotoboothBreakpoints.desktop + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        final widget = tester.widget<AnimatedPhotoboothPhotoWideDesktop>(
            find.byType(AnimatedPhotoboothPhotoWideDesktop));
        expect(widget.isPhotoVisible, false);
      });

      testWidgets(
          'displays AnimatedPhotoboothPhotoWideDesktop '
          'with isPhotoVisible false '
          'after 2 seconds', (tester) async {
        tester
            .setDisplaySize(const Size(PhotoboothBreakpoints.desktop + 1, 800));

        await tester.pumpApp(
          AnimatedPhotoboothPhoto(image: image),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump(Duration(seconds: 2));
        final widget = tester.widget<AnimatedPhotoboothPhotoWideDesktop>(
            find.byType(AnimatedPhotoboothPhotoWideDesktop));
        expect(widget.isPhotoVisible, true);
      });
    });
  });
}

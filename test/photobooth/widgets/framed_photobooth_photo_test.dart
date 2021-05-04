// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
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
  const aspectRatio = PhotoboothAspectRatio.landscape;

  late PhotoboothBloc photoboothBloc;

  setUpAll(() {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('FramedPhotoboothPhoto', () {
    testWidgets('displays PhotoboothPhoto', (tester) async {
      await tester.pumpApp(
        FramedPhotoboothPhoto(aspectRatio: aspectRatio, image: data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(PhotoboothPhoto), findsOneWidget);
    });

    testWidgets('transform image by default', (tester) async {
      await tester.pumpApp(
        FramedPhotoboothPhoto(aspectRatio: aspectRatio, image: data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets(
        'does not transform image '
        'when isTilted is false', (tester) async {
      await tester.pumpApp(
        FramedPhotoboothPhoto(
          aspectRatio: aspectRatio,
          image: data,
          isTilted: false,
        ),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(Transform), findsNothing);
    });
  });
}

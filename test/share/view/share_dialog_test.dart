// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);
  final bytes = Uint8List.fromList(transparentImage);

  late PhotoboothBloc photoboothBloc;

  setUpAll(() {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('ShareDialog', () {
    testWidgets('displays heading', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byKey(Key('shareDialog_heading')), findsOneWidget);
    });

    testWidgets('displays subheading', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byKey(Key('shareDialog_subheading')), findsOneWidget);
    });

    testWidgets('displays a TwitterButton', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(TwitterButton), findsOneWidget);
    });

    testWidgets('displays a FacebookButton', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(FacebookButton), findsOneWidget);
    });

    testWidgets('taps on close will dismiss the popup', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsNothing);
    });
  });
}

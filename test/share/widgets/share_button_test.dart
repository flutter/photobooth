// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);
  final bytes = Uint8List.fromList(transparentImage);

  late PhotoboothBloc photoboothBloc;
  late PlatformHelper platformHelper;

  setUpAll(() {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
    platformHelper = MockPlatformHelper();
  });

  group('ShareButton', () {
    testWidgets(
        'tapping on share photo button opens ShareBottomSheet '
        'when platform is mobile', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(true);

      await tester.pumpApp(
        ShareButton(image: bytes),
        photoboothBloc: photoboothBloc,
      );

      await tester.tap(find.byType(ShareButton));
      await tester.pumpAndSettle();

      expect(find.byType(ShareBottomSheet), findsOneWidget);
    });

    testWidgets(
        'tapping on share photo button opens ShareBottomSheet '
        'when platform is not mobile and it is portrait', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(false);
      tester.setPortraitDisplaySize();

      await tester.pumpApp(
        ShareButton(
          image: bytes,
          platformHelper: platformHelper,
        ),
        photoboothBloc: photoboothBloc,
      );

      await tester.tap(find.byType(ShareButton));
      await tester.pumpAndSettle();

      expect(find.byType(ShareBottomSheet), findsOneWidget);
    });

    testWidgets(
        'tapping on share photo button opens ShareDialog '
        'when platform is not mobile and it is landscape', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(false);
      tester.setLandscapeDisplaySize();
      await tester.pumpApp(
        ShareButton(
          image: bytes,
          platformHelper: platformHelper,
        ),
        photoboothBloc: photoboothBloc,
      );

      await tester.tap(find.byType(ShareButton));
      await tester.pumpAndSettle();

      expect(find.byType(ShareDialog), findsOneWidget);
    });
  });
}

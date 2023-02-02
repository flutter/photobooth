// ignore_for_file: prefer_const_constructors
import 'package:camera/camera.dart';
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

  late PhotoboothBloc photoboothBloc;

  setUpAll(() {
    registerFallbackValue(FakePhotoboothEvent());
    registerFallbackValue(FakePhotoboothState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('PhotoboothPhoto', () {
    testWidgets('displays PreviewImage', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays CharactersLayer', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(CharactersLayer), findsOneWidget);
    });

    testWidgets('displays StickersLayer', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(StickersLayer), findsOneWidget);
    });
  });
}

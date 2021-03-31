// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('PreviewImage', () {
    late CameraImage cameraImage;

    setUp(() {
      const width = 1;
      const height = 1;
      final data = Uint8List.fromList([]);

      cameraImage = CameraImage(
        height: height,
        width: width,
        imageData: ImageData(
          width: width,
          height: height,
          decoded: data,
          data: data,
        ),
      );
    });
    testWidgets('renders without width as parameter', (tester) async {
      await tester.pumpApp(PreviewImage(
        image: cameraImage,
        height: 100,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders without height as parameter', (tester) async {
      await tester.pumpApp(PreviewImage(
        image: cameraImage,
        width: 100,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders without height/width as parameter', (tester) async {
      await tester.pumpApp(PreviewImage(
        image: cameraImage,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });
  });
}

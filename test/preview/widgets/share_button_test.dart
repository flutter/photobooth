// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  final cameraImage = CameraImage(
    height: 1,
    width: 1,
    imageData: ImageData(
      width: 1,
      height: 1,
      decoded: Uint8List.fromList([]),
      data: Uint8List.fromList([]),
    ),
  );

  group('ShareButton', () {
    testWidgets('tapping on share photo button opens ShareDialog',
        (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      await tester.tap(find.byType(ShareButton));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsOneWidget);
    });
  });
}

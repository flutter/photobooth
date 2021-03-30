import 'dart:typed_data';

class CameraImage {
  const CameraImage({
    required this.data,
    required this.width,
    required this.height,
  });

  final Uint8List data;
  final int width;
  final int height;
}

import 'dart:typed_data';

class CameraImage {
  const CameraImage({
    required this.data,
    required this.width,
    required this.height,
  });

  /// Is a [Uint8List] representing a one-dimensional array containing the data
  /// in the RGBA order, with integer values between 0 and 255 (inclusive).
  final Uint8List data;

  /// Is an unsigned long representing the actual height,
  /// in pixels, of the image data.
  final int width;

  /// Is an unsigned long representing the actual width,
  /// in pixels, of the image data.
  final int height;
}

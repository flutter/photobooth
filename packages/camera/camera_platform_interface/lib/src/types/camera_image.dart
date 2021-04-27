class CameraImage {
  const CameraImage({
    required this.data,
    required this.width,
    required this.height,
  });

  /// A data URI containing a representation of the image ('image/png').
  final String data;

  /// Is an unsigned long representing the actual height,
  /// in pixels, of the image data.
  final int width;

  /// Is an unsigned long representing the actual width,
  /// in pixels, of the image data.
  final int height;
}

/// Unsupported Implementation of [ImageCompositor]
class ImageCompositor {
  /// Throws [UnsupportedError].
  Future<List<int>> composite({
    required String data,
    required int width,
    required int height,
    required List<dynamic> layers,
    required double aspectRatio,
  }) {
    throw UnsupportedError(
      'composite is not supported for the current host platform',
    );
  }
}

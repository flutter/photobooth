/// Unsupported Implementation of [ImageCompositor]

class ImageCompositor {
  /// Throws [UnsupportedError].
  Future<String> composite() {
    throw UnsupportedError(
      'composite is not supported for the current host platform',
    );
  }
}

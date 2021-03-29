abstract class CameraException implements Exception {
  const CameraException(this.description);
  final String description;
}

class CameraUnknownException implements CameraException {
  const CameraUnknownException();
  @override
  String get description => 'Unknown Error';
}

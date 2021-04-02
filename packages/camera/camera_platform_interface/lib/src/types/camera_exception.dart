abstract class CameraException implements Exception {
  const CameraException(this.description);
  final String description;
}

class CameraUnknownException implements CameraException {
  const CameraUnknownException();
  @override
  String get description => 'Unknown Error';
}

class CameraNotSupportedException implements CameraException {
  const CameraNotSupportedException();
  @override
  String get description => 'Not Supported';
}

class CameraAbortException implements CameraException {
  const CameraAbortException();
  @override
  String get description => 'Aborted';
}

class CameraNotAllowedException implements CameraException {
  const CameraNotAllowedException();
  @override
  String get description => 'Not Allowed';
}

class CameraNotFoundException implements CameraException {
  const CameraNotFoundException();
  @override
  String get description => 'Not Found';
}

class CameraNotReadableException implements CameraException {
  const CameraNotReadableException();
  @override
  String get description => 'Not Readable';
}

class CameraOverconstrainedException implements CameraException {
  const CameraOverconstrainedException();
  @override
  String get description => 'Overconstrained';
}

class CameraSecurityException implements CameraException {
  const CameraSecurityException();
  @override
  String get description => 'Security Error';
}

class CameraTypeException implements CameraException {
  const CameraTypeException();
  @override
  String get description => 'Type Error';
}

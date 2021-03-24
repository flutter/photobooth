import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';

class CameraController {
  /// The id of a camera that hasn't been initialized.
  @visibleForTesting
  static const int kUninitializedCameraId = -1;
  int _cameraId = kUninitializedCameraId;

  bool _isDisposed = false;
  bool _isInitialized = false;

  /// The camera identifier with which the controller is associated.
  int get cameraId => _cameraId;

  /// Initializes the camera on the device.
  ///
  /// Throws a [CameraException] if the initialization fails.
  Future<void> initialize() async {
    if (_isDisposed) {
      throw CameraException(
        'Disposed CameraController',
        'initialize was called on a disposed CameraController',
      );
    }
    _cameraId = 0;
    await CameraPlatform.instance.initializeCamera(cameraId);
    _isInitialized = true;
  }

  /// Returns a widget showing a live camera preview.
  Widget buildPreview() {
    _throwIfNotInitialized('buildPreview');
    try {
      return CameraPlatform.instance.buildPreview(_cameraId);
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Captures an image and returns the file where it was saved.
  Future<XFile> takePicture() {
    _throwIfNotInitialized('takePicture');
    try {
      return CameraPlatform.instance.takePicture(_cameraId);
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Releases the resources of this camera.
  Future<void> dispose() async {
    if (_isDisposed) return;
    await CameraPlatform.instance.dispose(cameraId);
    _isDisposed = true;
  }

  void _throwIfNotInitialized(String functionName) {
    if (!_isInitialized) {
      throw CameraException(
        'Uninitialized CameraController',
        '$functionName() was called on an uninitialized CameraController.',
      );
    }
    if (_isDisposed) {
      throw CameraException(
        'Disposed CameraController',
        '$functionName() was called on a disposed CameraController.',
      );
    }
  }
}

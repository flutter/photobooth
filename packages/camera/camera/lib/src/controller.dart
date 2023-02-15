part of '../camera.dart';

enum CameraStatus { uninitialized, available, unavailable }

class CameraState {
  const CameraState._({
    this.status = CameraStatus.uninitialized,
    this.error,
  });

  const CameraState.uninitialized() : this._();
  const CameraState.available() : this._(status: CameraStatus.available);
  const CameraState.unavailable(CameraException error)
      : this._(status: CameraStatus.unavailable, error: error);

  final CameraStatus status;
  final CameraException? error;
}

class CameraController extends ValueNotifier<CameraState> {
  CameraController({this.options = const CameraOptions()})
      : _cameraPlatform = CameraPlatform.instance,
        super(const CameraState.uninitialized());

  final CameraOptions options;
  final CameraPlatform _cameraPlatform;

  // The id of a texture that hasn't been initialized.
  @visibleForTesting
  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  bool get _isInitialized => _textureId != kUninitializedTextureId;

  /// This is just exposed for testing. It shouldn't be used by anyone depending
  /// on the plugin.
  @visibleForTesting
  int get textureId => _textureId;

  /// Attempts to use the given [options] to initialize a camera.
  Future<void> initialize() async {
    try {
      await _cameraPlatform.init();
      _textureId = await _cameraPlatform.create(options);
      value = const CameraState.available();
    } on CameraException catch (e) {
      value = CameraState.unavailable(e);
    } catch (e) {
      value = const CameraState.unavailable(CameraUnknownException());
    }
  }

  Future<void> play() => _cameraPlatform.play(_textureId);
  Future<void> stop() => _cameraPlatform.stop(_textureId);

  Future<CameraImage> takePicture() {
    return _cameraPlatform.takePicture(_textureId);
  }

  @override
  Future<void> dispose() async {
    if (_isInitialized) {
      await _cameraPlatform.dispose(_textureId);
    }
    value = const CameraState.uninitialized();
    super.dispose();
  }
}

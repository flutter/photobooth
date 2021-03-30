part of tensorflow_models_platform_interface;

/// The interface that implementations of tensorflow must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `TensorflowModels` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [TensorflowModelsPlatform] methods.
abstract class TensorflowModelsPlatform extends PlatformInterface {
  /// Constructs a ConnectivityPlatform.
  TensorflowModelsPlatform() : super(token: _token);

  static final Object _token = Object();

  static TensorflowModelsPlatform _instance = MethodChannelTensorflowModels();

  /// The default instance of [TensorflowModelsPlatform] to use.
  ///
  /// Defaults to [MethodChannelTensorflowModels].
  static TensorflowModelsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TensorflowModelsPlatform]
  /// when they register themselves.
  static set instance(TensorflowModelsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<PoseNet> loadPosenet([ModelConfig? config]) {
    throw UnimplementedError('loadPosenet() has not been implemented.');
  }
}

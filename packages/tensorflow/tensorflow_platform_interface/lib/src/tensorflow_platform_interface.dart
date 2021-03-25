import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tensorflow_platform_interface/src/models/pose.dart';

import 'method_channel_tensorflow.dart';
import 'models/models.dart';

/// The interface that implementations of tensorflow must implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `Tensorflow` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [TensorflowPlatform] methods.
abstract class TensorflowPlatform extends PlatformInterface {
  /// Constructs a ConnectivityPlatform.
  TensorflowPlatform() : super(token: _token);

  static final Object _token = Object();

  static TensorflowPlatform _instance = MethodChannelTensorflow();

  /// The default instance of [TensorflowPlatform] to use.
  ///
  /// Defaults to [MethodChannelTensorflow].
  static TensorflowPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TensorflowPlatform] when they register themselves.
  static set instance(TensorflowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Pose> estimateSinglePose(XFile image) {
    throw UnimplementedError('estimateSinglePose() is not implemented.');
  }

  Future<void> loadModel() {
    throw UnimplementedError('loadModel() is not implemented.');
  }

  Future<Keypoint> getShoulder(XFile image) {
    throw UnimplementedError('getShoulder() is not implemented.');
  }

  Future<Pose> estimateSinglePoseFromBytes(Uint8List bytes) {
    throw UnimplementedError(
        'estimateSinglePoseFromBytes() is not implemented.');
  }
}

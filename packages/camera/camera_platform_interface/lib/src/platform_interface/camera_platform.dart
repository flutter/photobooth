import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_platform_interface/src/method_channel/method_channel_camera.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class CameraPlatform extends PlatformInterface {
  /// Constructs a CameraPlatform.
  CameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraPlatform _instance = MethodChannelCamera();

  /// The default instance of [CameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelCamera].
  static CameraPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CameraPlatform] when they register themselves.
  static set instance(CameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform interface and disposes all existing cameras.
  ///
  /// This method is called when the plugin is first initialized
  /// and on every full restart.
  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Clears one camera.
  Future<void> dispose(int textureId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Creates an instance of a camera and returns its textureId.
  Future<int> create(CameraOptions options) {
    throw UnimplementedError('create() has not been implemented.');
  }

  /// Starts the camera stream.
  Future<void> play(int textureId) {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// Stops the camera stream.
  Future<void> stop(int textureId) {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Widget buildView(int textureId) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  Future<CameraImage> takePicture(int textureId) {
    throw UnimplementedError('takePicture() has not been implemented.');
  }

  Future<List<MediaDeviceInfo>> getMediaDevices() {
    throw UnimplementedError('getDevicesIds() has not been implemented.');
  }

  Future<String?> getDefaultDeviceId() {
    throw UnimplementedError('getDefaultDeviceId() has not been implemented.');
  }
}

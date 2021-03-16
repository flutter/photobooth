import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/src/camera_preview.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// The web implementation of [CameraPlatform].
///
/// This class implements the `package:camera` functionality for the web.
class CameraPlugin extends CameraPlatform {
  // Factory method that initializes the camera plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    CameraPlatform.instance = CameraPlugin();
  }

  @override
  Widget buildPreview(int cameraId) => CameraPreview(cameraId: cameraId);
}

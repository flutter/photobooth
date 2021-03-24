import 'dart:convert';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'web_camera.dart';

/// The web implementation of [CameraPlatform].
///
/// This class implements the `package:camera` functionality for the web.
class CameraPlugin extends CameraPlatform {
  // Factory method that initializes the camera plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    CameraPlatform.instance = CameraPlugin();
  }

  @visibleForTesting
  late WebCamera camera;

  @override
  Future<void> initializeCamera(
    int cameraId, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) async {
    camera = WebCamera(cameraId);
  }

  @override
  Future<List<CameraDescription>> availableCameras() {
    return camera.availableCameras();
  }

  @override
  Widget buildPreview(int cameraId) => camera.buildPreview();

  @override
  Future<XFile> takePicture(int cameraId) async {
    final image = await camera.takePicture();
    return XFile.fromData(base64.decode(image.split(',')[1]));
  }

  @override
  Future<void> dispose(int cameraId) async {
    camera.stopPreview();
  }
}

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';
import 'package:tensorflow_web/src/utils.dart';

class TensorflowPlugin extends TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }

  @override
  Future<Pose> estimateSinglePose(XFile image) async {
    final imageData = await getImageDataFromXFile(image);
    await posenet.load();
    final poseInterop = await posenet.estimateSinglePose(imageData);
    return poseInterop.parsePose();
  }

  @override
  Future<Pose> estimateSinglePoseFromBytes(Uint8List bytes) async {
    final imageData = getImageDataFromBytes(bytes);

    await posenet.load();
    final poseInterop = await posenet.estimateSinglePose(imageData);
    return poseInterop.parsePose();
  }
}

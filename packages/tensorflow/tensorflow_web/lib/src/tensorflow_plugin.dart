import 'dart:html';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:tensorflow_web/src/utils.dart';
import 'package:tfdart/tfdart.dart' as tfdart;

class TensorflowPlugin extends TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }

  @override
  Future<Pose> estimateSinglePose(XFile image) async {
    final imageData = await getImageDataFromXFile(image);
    final result =
        await js_util.promiseToFuture<Object>(tfdart.estimatePose(imageData));
    return pluginPoseFromObject(result);
  }

  @override
  Future<void> loadModel() async {
    await js_util.promiseToFuture(tfdart.loadModel());
  }

  @override
  Future<Keypoint> getShoulder(XFile image) async {
    final pose = await estimateSinglePose(image);
    return pose.keypoints[5];
  }

  @override
  Future<Pose> estimateSinglePoseFromBytes(Uint8List bytes) async {
    final imageData = getImageDataFromBytes(bytes);

    final result =
        await js_util.promiseToFuture<Object>(tfdart.estimatePose(imageData));
    return pluginPoseFromObject(result);
  }
}

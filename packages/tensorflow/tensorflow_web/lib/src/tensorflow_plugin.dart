import 'dart:html';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';
import 'package:js/js_util.dart' as js_util;

import 'plugin_interop.dart' as interop;

class TensorflowPlugin extends TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }

  @override
  Future<Pose> estimateSinglePose(XFile image) {
    throw UnimplementedError('estimateSinglePose() is not implemented.');
  }

  @override
  Future<void> loadModel() async {
    await js_util.promiseToFuture(interop.loadModel());
  }

  @override
  Future<Keypoint> getShoulder(ImageData image) async {
    final result =
        await js_util.promiseToFuture<Object>(interop.getLeftShoulder(image));
    final resultParsed = interop.convertPrediction(result);
    return Keypoint(
        score: resultParsed.score.toDouble(),
        position: Vector2D(
            x: resultParsed.position.x.toDouble(),
            y: resultParsed.position.y.toDouble()),
        part: resultParsed.part);
  }
}

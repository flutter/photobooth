import 'package:cross_file/cross_file.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:tfdart/tfdart.dart' as tfdart;

class TensorflowPlugin extends TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }

  @override
  Future<Pose> estimateSinglePose(dynamic image) async {
    final result =
        await js_util.promiseToFuture<Object>(tfdart.estimatePose(image));
    final tfdartPose = tfdart.convertPose(result);
    var keypoints = <Keypoint>[];
    for (var item in tfdartPose.keypoints) {
      keypoints.add(
        Keypoint(
          score: item.score.toDouble(),
          position: Vector2D(
            x: item.position.x.toDouble(),
            y: item.position.y.toDouble(),
          ),
          part: item.part,
        ),
      );
    }
    return Pose(keypoints: keypoints, score: tfdartPose.score.toDouble());
  }

  @override
  Future<void> loadModel() async {
    await js_util.promiseToFuture(tfdart.loadModel());
  }

  @override
  Future<Keypoint> getShoulder(dynamic image) async {
    final pose = await estimateSinglePose(image);
    return pose.keypoints[5];
  }
}

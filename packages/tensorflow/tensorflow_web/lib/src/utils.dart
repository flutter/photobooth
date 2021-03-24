import 'package:tfdart/tfdart.dart' as tfdart;

import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

Pose pluginPoseFromObject(Object object) {
  final tfPose = tfdart.convertPose(object);
  var keypoints = <Keypoint>[];
  for (var item in tfPose.keypoints) {
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
  return Pose(keypoints: keypoints, score: tfPose.score.toDouble());
}

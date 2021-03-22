import 'package:tensorflow_platform_interface/src/models/keypoint.dart';

class Pose {
  Pose({
    required this.keypoints,
    required this.score,
  });
  List<Keypoint> keypoints;
  double score;
}

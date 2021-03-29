part of tensorflow_models_platform_interface;

abstract class PoseNet {
  Future<Pose> estimateSinglePose(
    ImageData imageData,
  );
}

class ImageData {
  const ImageData({
    required this.data,
    required this.width,
    required this.height,
  });

  final Uint8ClampedList data;
  final int width;
  final int height;
}

class Pose {
  const Pose({required this.keypoints, required this.score});

  final List<Keypoint> keypoints;
  final num score;
}

class Keypoint {
  const Keypoint({
    required this.score,
    required this.position,
    required this.part,
  });

  final num score;
  final Vector2D position;
  final String part;
}

class Vector2D {
  const Vector2D({required this.y, required this.x});
  final num y;
  final num x;
}

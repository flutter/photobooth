import 'package:tensorflow_platform_interface/src/models/vector_2d.dart';

class Keypoint {
  Keypoint({
    required this.score,
    required this.position,
    required this.part,
  });
  double score; // confidence in the result
  Vector2D position; // position of the part respect of the image
  String part; //part of the body

  @override
  String toString() {
    return 'Part: $part x=${position.x} y=${position.y}'
        ' score: ${score.toStringAsFixed(2)}';
  }
}

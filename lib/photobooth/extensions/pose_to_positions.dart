import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;

const _minPoseConfidence = 0.1;
const _minPartConfidence = 0.5;
const _supportedParts = ['leftShoulder', 'rightShoulder'];

extension PoseToPositions on posenet.Pose {
  List<Offset> toPositions({
    required ui.Image image,
    Size scale = const Size(1.0, 1.0),
  }) {
    final positions = <Offset>[];
    if (score < _minPoseConfidence) return positions;
    for (final keypoint in keypoints) {
      if (!_supportedParts.contains(keypoint.part)) continue;
      if (keypoint.score < _minPartConfidence) continue;
      final x = keypoint.position.x.ceilToDouble();
      final y = keypoint.position.y.ceilToDouble();
      final offset = Offset(x * scale.width, y * scale.height);
      final normalizedOffset = Offset(
        (offset.dx - image.width / 2),
        ((offset.dy - image.height) - 50),
      );
      positions.add(normalizedOffset);
    }
    return positions;
  }
}

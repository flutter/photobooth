import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

import 'posenet_interop.dart' as posenet;
export 'posenet_interop.dart';

Future<PoseNetWeb> load([posenet.ModelConfig? config]) async {
  return PoseNetWeb.fromJs(await promiseToFuture(posenet.load(config)));
}

class PoseNetWeb implements PoseNet {
  factory PoseNetWeb.fromJs(posenet.PoseNet net) {
    return PoseNetWeb._(net);
  }

  PoseNetWeb._(this._net)
      : baseModel = _net.baseModel,
        inputResolution = _net.inputResolution;

  final posenet.BaseModel baseModel;
  final List<int> inputResolution;
  final posenet.PoseNet _net;

  /// Returns a pose estimation for an ImageData
  @override
  Future<Pose> estimateSinglePose(
    ImageData imageData, {
    SinglePersonInterfaceConfig? config,
  }) async {
    final pose = await promiseToFuture<posenet.Pose>(
      _net.estimateSinglePose(imageData.toJs(), config?.toJs()),
    );
    return pose.fromJs();
  }

  @override
  void dispose() => _net.dispose();
}

extension on SinglePersonInterfaceConfig {
  posenet.SinglePersonInterfaceConfig toJs() {
    return posenet.SinglePersonInterfaceConfig(flipHorizontal: flipHorizontal);
  }
}

extension on ImageData {
  html.ImageData toJs() => html.ImageData(data, width, height);
}

extension on posenet.Pose {
  Pose fromJs() {
    return Pose(
      keypoints: keypoints.map((k) => k.fromJs()).toList(),
      score: score,
    );
  }
}

extension on posenet.Keypoint {
  Keypoint fromJs() {
    return Keypoint(score: score, position: position.fromJs(), part: part);
  }
}

extension on posenet.Vector2D {
  Vector2D fromJs() => Vector2D(x: x, y: y);
}

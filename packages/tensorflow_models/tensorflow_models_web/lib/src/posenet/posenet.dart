import 'dart:async';
import 'dart:html';
import 'dart:js_util';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

import 'posenet_interop.dart' as posenet;
export 'posenet_interop.dart';

/// Loads a pre-trained PoseNet Model.
///
/// PoseNet comes with a few different versions of the model,
/// corresponding to variances of MobileNet v1 architecture
/// and ResNet50 architecture.
///
/// To get started, a model must be loaded from a checkpoint:
///
/// ```dart
/// final net = await posenet.load();
/// ```
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
    posenet.SinglePersonInterfaceConfig? config,
  }) async {
    final pose = await promiseToFuture<posenet.Pose>(
      _net.estimateSinglePose(imageData, config),
    );
    return Pose(keypoints: List.from(pose.keypoints), score: pose.score);
  }
}

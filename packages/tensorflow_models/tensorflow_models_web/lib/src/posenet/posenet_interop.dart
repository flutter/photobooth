@JS('posenet')
library posenet;

import 'package:js/js.dart';

@JS()
external Promise<PoseNet> load([ModelConfig? config]);

@JS()
@anonymous
class PoseNet {
  external factory PoseNet({
    BaseModel baseModel,
    List<int> inputResolution,
  });

  external BaseModel get baseModel;
  external List<int> get inputResolution;
  external Promise<Pose> estimateSinglePose(
    Object input, [
    SinglePersonInterfaceConfig? config,
  ]);
  external void dispose();
}

@JS()
@anonymous
class BaseModel {
  external dynamic get model;
  external int get outputStride;
}

@JS()
@anonymous
class ModelConfig {
  external factory ModelConfig({
    String? architecture,
    int? outputStride,
    dynamic inputResolution,
    double? multiplier,
    int? quantBytes,
  });
}

@JS()
@anonymous
abstract class SinglePersonInterfaceConfig extends InferenceConfig {
  external factory SinglePersonInterfaceConfig({bool? flipHorizontal});
}

@JS()
@anonymous
class InferenceConfig {
  external factory InferenceConfig({bool? flipHorizontal});
}

@JS()
@anonymous
class Pose {
  external factory Pose({List<Keypoint> keypoints, num score});
  external List<Keypoint> get keypoints;
  external num get score;
}

@JS()
@anonymous
class Keypoint {
  external factory Keypoint({
    num score,
    Vector2D position,
    String part,
  });
  external num get score;
  external Vector2D get position;
  external String get part;
}

@JS()
@anonymous
class Vector2D {
  external factory Vector2D({num y, num x});
  external num get y;
  external num get x;
}

@JS()
class Promise<T> {
  external Promise(void Function(T result) executor, void Function() reject);
  external Promise then(
    void Function(T result) onFulfilled, [
    void Function() onRejected,
  ]);
}

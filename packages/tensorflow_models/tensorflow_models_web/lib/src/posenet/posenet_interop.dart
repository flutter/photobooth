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
    ///  Can be either MobileNetV1 or ResNet50.
    /// It determines which PoseNet architecture to load.
    String architecture,

    /// Can be one of 8, 16, 32.
    /// Stride 16, 32 are supported for the ResNet architecture
    /// Stride 8, 16, 32 are supported for the MobileNetV1 architecture.
    /// If you are using stride 32 you must set the multiplier to 1.0.
    /// It specifies the output stride of the PoseNet model.
    /// The smaller the value, the larger the output resolution,
    /// and more accurate the model at the cost of speed.
    /// Set this to a larger value to increase speed at the cost of accuracy.
    int outputStride,

    /// A number or an Object of type `{width: number, height: number}`.
    /// Defaults to 257.
    ///
    /// It specifies the size the image is resized and padded to
    /// before it is fed into the PoseNet model.
    /// The larger the value, the more accurate the model at the cost of speed.
    /// Set this to a smaller value to increase speed at the cost of accuracy.
    /// If a number is provided, the image will be resized and padded
    /// to be a square with the same width and height.
    /// If width and height are provided, the image will be resized and padded
    /// to the specified width and height.
    Map<String, int> inputResolution,

    /// Can be one of 1.0, 0.75, or 0.50.
    /// The value is used only by the MobileNetV1 architecture.
    /// It's the multiplier for the depth (# channels) for all convolution ops.
    /// The larger the value, the larger the size of the layers,
    /// and more accurate the model at the cost of speed.
    /// Set this to a smaller value to increase speed at the cost of accuracy.
    double multiplier,

    /// This argument controls the bytes used for weight quantization.
    ///
    /// The available options are:
    ///
    /// * `4` - 4 bytes per float (no quantization).
    /// Leads to highest accuracy and original model size (~90MB).
    ///
    /// * `2` - 2 bytes per float.
    /// Leads to slightly lower accuracy and 2x model size reduction (~45MB).
    ///
    /// * `1` - 1 byte per float.
    /// Leads to lower accuracy and 4x model size reduction (~22MB).
    int quantBytes,
  });
}

@JS()
@anonymous
abstract class SinglePersonInterfaceConfig extends InferenceConfig {
  external factory SinglePersonInterfaceConfig({bool flipHorizontal});
}

@JS()
@anonymous
class InferenceConfig {
  external factory InferenceConfig({bool flipHorizontal});
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

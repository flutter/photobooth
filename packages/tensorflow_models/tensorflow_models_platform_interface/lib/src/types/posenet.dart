part of tensorflow_models_platform_interface;

class ModelConfig {
  const ModelConfig({
    this.architecture,
    this.outputStride,
    this.inputResolution,
    this.multiplier,
    this.quantBytes,
  });

  ///  Can be either MobileNetV1 or ResNet50.
  /// It determines which PoseNet architecture to load.
  final String? architecture;

  /// Can be one of 8, 16, 32.
  /// Stride 16, 32 are supported for the ResNet architecture
  /// Stride 8, 16, 32 are supported for the MobileNetV1 architecture.
  /// If you are using stride 32 you must set the multiplier to 1.0.
  /// It specifies the output stride of the PoseNet model.
  /// The smaller the value, the larger the output resolution,
  /// and more accurate the model at the cost of speed.
  /// Set this to a larger value to increase speed at the cost of accuracy.
  final int? outputStride;

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
  final dynamic inputResolution;

  /// Can be one of 1.0, 0.75, or 0.50.
  /// The value is used only by the MobileNetV1 architecture.
  /// It's the multiplier for the depth (# channels) for all convolution ops.
  /// The larger the value, the larger the size of the layers,
  /// and more accurate the model at the cost of speed.
  /// Set this to a smaller value to increase speed at the cost of accuracy.
  final double? multiplier;

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
  final int? quantBytes;
}

abstract class PoseNet {
  Future<Pose> estimateSinglePose(
    ImageData imageData, {
    SinglePersonInterfaceConfig? config,
  });

  void dispose();
}

class SinglePersonInterfaceConfig extends InferenceConfig {
  const SinglePersonInterfaceConfig({bool? flipHorizontal})
      : super(flipHorizontal: flipHorizontal);
}

class InferenceConfig {
  const InferenceConfig({this.flipHorizontal});

  final bool? flipHorizontal;
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

import 'package:tensorflow_models/tensorflow_models.dart';

export 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// Loads a pre-trained PoseNet Model.
///
/// PoseNet comes with a few different versions of the model,
/// corresponding to variances of MobileNet v1 architecture
/// and ResNet50 architecture.
///
/// To get started, a model must be loaded from a checkpoint:
///
/// ```dart
/// import 'package:tensorflow_models/posenet.dart' as posenet;
///
/// final net = await posenet.load();
/// ```
Future<PoseNet> load([ModelConfig? config]) async {
  return TensorflowModelsPlatform.instance.loadPosenet(config);
}

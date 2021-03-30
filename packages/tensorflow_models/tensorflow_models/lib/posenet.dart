import 'package:tensorflow_models/tensorflow_models.dart';

/// Loads the PoseNet model instance from a checkpoint, with the ResNet
/// or MobileNet architecture. The model to be loaded is configurable using the
/// config dictionary ModelConfig. Please find more details in the
/// documentation of the ModelConfig.
///
/// [config] [ModelConfig] object contains parameters for
/// the PoseNet loading process. Please find more details of each parameters
/// in the documentation of the [ModelConfig] interface.
Future<PoseNet> load([ModelConfig? config]) async {
  return TensorflowModelsPlatform.instance.loadPosenet(config);
}

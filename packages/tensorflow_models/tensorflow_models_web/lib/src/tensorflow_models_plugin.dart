import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/posenet/posenet.dart' as posenet;

class TensorflowModelsPlugin extends TensorflowModelsPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowModelsPlatform.instance = TensorflowModelsPlugin();
  }

  @override
  Future<PoseNet> loadPosenet([ModelConfig? config]) {
    return posenet.load(
      posenet.ModelConfig(
        architecture: config?.architecture,
        outputStride: config?.outputStride,
        inputResolution: config?.inputResolution,
        multiplier: config?.multiplier,
        quantBytes: config?.quantBytes,
      ),
    );
  }
}

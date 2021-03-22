import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

class TensorflowPlugin extends TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }

  @override
  Future<Pose> estimateSinglePose(dynamic image) {
    throw UnimplementedError('estimateSinglePose() is not implemented.');
  }
}

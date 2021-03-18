import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

class TensorflowPlugin implements TensorflowPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowPlatform.instance = TensorflowPlugin();
  }
}

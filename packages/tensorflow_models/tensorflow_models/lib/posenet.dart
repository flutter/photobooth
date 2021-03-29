import 'package:tensorflow_models/tensorflow_models.dart';

Future<PoseNet> load() async {
  return TensorflowModelsPlatform.instance.loadPosenet();
}

import 'dart:html';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:tfdart/tfdart.dart' as tfdart;

import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

Pose pluginPoseFromObject(Object object) {
  final tfPose = tfdart.convertPose(object);
  var keypoints = <Keypoint>[];
  for (var item in tfPose.keypoints) {
    keypoints.add(
      Keypoint(
        score: item.score.toDouble(),
        position: Vector2D(
          x: item.position.x.toDouble(),
          y: item.position.y.toDouble(),
        ),
        part: item.part,
      ),
    );
  }
  return Pose(keypoints: keypoints, score: tfPose.score.toDouble());
}

Future<ImageData> getImageDataFromXFile(XFile xFile) async {
  final data = await xFile.readAsBytes();
  final bytesClamped = Uint8ClampedList.fromList(data);
  final image = ImageData(bytesClamped, 1000);
  return image;
}

ImageData getImageDataFromBytes(Uint8List bytes) {
  final bytesClamped = Uint8ClampedList.fromList(bytes);
  final image = ImageData(bytesClamped, 10000);
  return image;
}

import 'dart:html';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:image/image.dart' as image_api;
import 'package:tensorflow_models/posenet/posenet_interop.dart'
    as posenet_interop;

import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

extension ParsingPose on posenet_interop.Pose {
  Pose parsePose() {
    return Pose(
        keypoints: keypoints
            .map(
              (e) => e.parseKeypoint(),
            )
            .toList(),
        score: score.toDouble());
  }
}

extension ParsingKeypoint on posenet_interop.Keypoint {
  Keypoint parseKeypoint() {
    return Keypoint(
      score: score.toDouble(),
      position: position.parsePosition(),
      part: part,
    );
  }
}

extension ParsingPosition on posenet_interop.Vector2D {
  Vector2D parsePosition() {
    return Vector2D(
      x: x.toDouble(),
      y: y.toDouble(),
    );
  }
}

Future<ImageData> getImageDataFromXFile(XFile xFile) async {
  final data = await xFile.readAsBytes();
  final bytesClamped = Uint8ClampedList.fromList(data);
  final image = ImageData(bytesClamped, 1000);
  return image;
}

ImageData getImageDataFromBytes(Uint8List bytes) {
  final bytesClamped = Uint8ClampedList.fromList(bytes);
  final decoded = image_api.decodeImage(bytesClamped);

  if (decoded == null) throw Exception('Decode image returns null');
  final canvas = CanvasElement(width: decoded.width, height: decoded.height);
  var imageData = canvas.context2D.createImageData(
    decoded.width,
    decoded.height,
  );
  imageData.data.setRange(0, decoded.length, decoded.getBytes());

  return imageData;
}

@JS()
library main;

import 'dart:html';
import 'package:js/js.dart';

@JS('loadModel')
external Future<void> loadModel();

@JS('estimatePose')
external Object estimatePose(ImageData image);

@JS('JSON.stringify')
external String stringify(Object obj);

@JS('JSON.parse')
external Pose poseFromJson(String str);

@JS('JSON.parse')
external Keypoint keypointFromJson(String str);

@anonymous
@JS()
abstract class Pose {
  external factory Pose({List<Keypoint> keypoints, num score});
  external List<Keypoint> get keypoints;
  external set keypoints(List<Keypoint> v);
  external num get score;
  external set score(num v);
}

@anonymous
@JS()
abstract class Keypoint {
  external factory Keypoint({num score, Vector2D position, String part});
  external num get score;
  external set score(num v);
  external Vector2D get position;
  external set position(Vector2D v);
  external String get part;
  external set part(String v);
}

@anonymous
@JS()
abstract class Vector2D {
  external factory Vector2D({num y, num x});
  external num get y;
  external set y(num v);
  external num get x;
  external set x(num v);
}

Pose convertPose(Object _val) {
  final _jsString = stringify(_val);
  return poseFromJson(_jsString);
}

Keypoint convertKeypoint(Object _val) {
  final _jsString = stringify(_val);
  return keypointFromJson(_jsString);
}

List<Keypoint> convertKeypoints(List<Object> _val) {
  final _keypoints = <Keypoint>[];

  for (final item in _val) {
    final _jsString = stringify(item);
    _keypoints.add(convertKeypoint(_jsString));
  }

  return _keypoints;
}

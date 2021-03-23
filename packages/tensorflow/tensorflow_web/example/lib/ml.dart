@JS()
library main;

import 'dart:html';
import 'package:js/js.dart';

@JS('estimatePose')
external dynamic estimatePose(ImageData image);

@JS('getLeftShoulder')
external Object getLeftShoulder(ImageData image);

@JS('JSON.stringify')
external String stringify(Object obj);

@JS('JSON.parse')
external PredictionResult jsonObject(String str);

@JS()
@anonymous
class PredictionResult {
  external factory PredictionResult({
    String part,
    Position position,
    num score,
  });

  external String get part;
  external Position get position;
  external num get score;
}

@JS()
@anonymous
class Position {
  external factory Position({
    num x,
    num y,
  });

  external num get x;
  external num get y;
}

PredictionResult convertPrediction(Object _val) {
  final _jsString = stringify(_val);
  return jsonObject(_jsString);
}

@JS()
library main;

import 'dart:html';
import 'package:js/js.dart';
import "dart:html" show ImageData;

@JS('estimatePose')
external dynamic estimatePose(CustomImageData image);

@JS('testJsMethod')
external void testJsMethod();
@JS('loadModel')
external void loadModel();

@anonymous
@JS()
abstract class CustomImageData {
  external ImageData get imageData;
  external set imageData(ImageData imageData);
  external factory CustomImageData({ImageData imageData});
}

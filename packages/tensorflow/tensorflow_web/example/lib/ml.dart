@JS()
library main;

import 'dart:html';
import 'package:js/js.dart';

@JS('estimatePose')
external dynamic estimatePose(ImageData image);

@JS('getLeftShoulder')
external dynamic getLeftShoulder(ImageData image);

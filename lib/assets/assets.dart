import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

abstract class Assets {
  static late final Asset android;
  static late final Asset dash;
  static late final Asset sparky;

  static bool _initialized = false;

  static Future<void> load() async {
    if (_initialized) return;
    final assets = await Future.wait([
      _loadAsset('assets/images/android.png'),
      _loadAsset('assets/images/dash.png'),
      _loadAsset('assets/images/sparky.png'),
    ]);
    android = assets[0];
    dash = assets[1];
    sparky = assets[2];
    _initialized = true;
  }
}

Future<Asset> _loadAsset(String path) async {
  final data = await rootBundle.load(path);
  final bytes = Uint8List.view(data.buffer);
  final image = await decodeImageFromList(bytes);
  final imageBytes = await image.toByteData();

  return Asset(image: image, buffer: imageBytes!.buffer, bytes: bytes);
}

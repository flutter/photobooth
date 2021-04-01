import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

abstract class Assets {
  static late final Asset dash;

  static bool _initialized = false;

  static Future<void> load() async {
    if (_initialized) return;
    final assets = await Future.wait([
      _loadAsset('assets/images/dash.png'),
    ]);
    dash = assets[0];
    _initialized = true;
  }
}

Future<Asset> _loadAsset(String path) async {
  final data = await rootBundle.load(path);
  final image = await decodeImageFromList(Uint8List.view(data.buffer));
  return Asset(image: image, buffer: data.buffer);
}

class Asset {
  const Asset({required this.image, required this.buffer});

  final ui.Image image;
  final ByteBuffer buffer;
}

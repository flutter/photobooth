import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
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
  final bytes = Uint8List.view(data.buffer);
  final image = await decodeImageFromList(bytes);
  final imageBytes = await image.toByteData();

  return Asset(image: image, buffer: imageBytes!.buffer, bytes: bytes);
}

class Asset extends Equatable {
  const Asset({required this.image, required this.buffer, required this.bytes});

  final ui.Image image;
  final ByteBuffer buffer;
  final Uint8List bytes;

  @override
  List<Object?> get props => [image, buffer, bytes];
}

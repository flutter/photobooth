import 'dart:typed_data';
import 'dart:ui' as ui;

/// {@template asset}
/// A Dart object which holds metadata for a given asset.
/// {@endtemplate}
class Asset {
  /// {@macro asset}
  const Asset({
    required this.name,
    required this.image,
    required this.buffer,
    required this.bytes,
    required this.path,
  });

  /// The [ui.Image] instance.
  final ui.Image image;

  /// The name of the image.
  final String name;

  /// The image buffer.
  final ByteBuffer buffer;

  /// The image bytes (useful for rendering images via `Image.memory`).
  final Uint8List bytes;

  /// The path to the asset
  final String path;
}

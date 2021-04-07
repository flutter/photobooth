import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';

/// {@template asset}
/// A Dart object which holds metadata for a given asset.
/// {@endtemplate}
class Asset extends Equatable {
  /// {@macro asset}
  const Asset({required this.image, required this.buffer, required this.bytes});

  /// The [ui.Image] instance.
  final ui.Image image;

  /// The image buffer.
  final ByteBuffer buffer;

  /// THe image bytes (useful for rendering images via `Image.memory`).
  final Uint8List bytes;

  @override
  List<Object?> get props => [image, buffer, bytes];
}

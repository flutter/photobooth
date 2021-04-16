import 'dart:typed_data';

import 'package:flutter/material.dart';

/// {@template preview_image}
/// A wrapper around [Image.memory]
/// {@endtemplate}
class PreviewImage extends StatelessWidget {
  /// {@macro preview_image}
  const PreviewImage({
    Key? key,
    required this.data,
    this.height,
    this.width,
  }) : super(key: key);

  /// [Uint8List] representing the data of the image
  final Uint8List data;

  /// [double?] representing the height of the image
  final double? height;

  /// [double?] representing the width of the image
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      Uint8List.fromList(data),
      filterQuality: FilterQuality.high,
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return Text(
          '$error, $stackTrace',
          key: const Key('previewImage_errorText'),
        );
      },
    );
  }
}

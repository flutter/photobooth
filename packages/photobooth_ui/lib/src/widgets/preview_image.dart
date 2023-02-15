import 'package:flutter/material.dart';

/// {@template preview_image}
/// A wrapper around [Image.memory]
/// {@endtemplate}
class PreviewImage extends StatelessWidget {
  /// {@macro preview_image}
  const PreviewImage({
    required this.data,
    this.height,
    this.width,
    super.key,
  });

  /// Data URI representing the data of the image
  final String data;

  /// [double?] representing the height of the image
  final double? height;

  /// [double?] representing the width of the image
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      data,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      fit: BoxFit.cover,
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

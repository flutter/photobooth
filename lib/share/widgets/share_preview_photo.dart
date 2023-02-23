import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePreviewPhoto extends StatelessWidget {
  const SharePreviewPhoto({required this.image, super.key});

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * (math.pi / 180),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: PhotoboothColors.black54,
              blurRadius: 7,
              offset: Offset(-3, 9),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Image.memory(
          image,
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

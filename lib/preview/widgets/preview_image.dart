import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({Key? key, required this.image, this.height, this.width})
      : super(key: key);

  final ImageData image;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      Uint8List.fromList(image.data),
      // isAntiAlias: true,
      // height: height,
      // width: 640,
      errorBuilder: (context, error, stackTrace) {
        return Text('Error, $error, $stackTrace');
      },
    );
    // return Transform.rotate(
    //   angle: -15 / 360,
    //   child: Image.memory(
    //     Uint8List.fromList(image.data),
    //     isAntiAlias: true,
    //     // height: height,
    //     // width: width,
    //     errorBuilder: (context, error, stackTrace) {
    //       return Text('Error, $error, $stackTrace');
    //     },
    //   ),
    // );
  }
}

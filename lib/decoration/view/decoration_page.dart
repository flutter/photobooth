import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/preview/preview.dart';

class DecorationPage extends StatelessWidget {
  const DecorationPage({Key? key, required this.image}) : super(key: key);

  final ImageData image;

  static Route route({required ImageData image}) {
    return MaterialPageRoute(builder: (_) => DecorationPage(image: image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(image: image),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () =>
                    Navigator.of(context).push(PreviewPage.route(image: image)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewImage extends StatelessWidget {
  const PreviewImage({
    Key? key,
    required this.image,
    this.height,
    this.width,
  }) : super(key: key);

  final ImageData image;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      Uint8List.fromList(image.data),
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return Text('$error, $stackTrace');
      },
    );
  }
}

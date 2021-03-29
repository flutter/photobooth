import 'dart:typed_data';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  final Uint8List image;

  static Route route({required Uint8List image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.memory(
          Uint8List.fromList(image),
          errorBuilder: (context, error, stackTrace) {
            return Text('Error, $error, $stackTrace');
          },
        ),
      ),
    );
  }
}

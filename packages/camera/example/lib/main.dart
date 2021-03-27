import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

const _cameraOptions = CameraOptions(audio: AudioConstraints(enabled: false));

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(options: _cameraOptions);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSnapPressed() async {
    final image = await _controller.takePicture();
    final previewPageRoute = PreviewPage.route(image: image);
    await Navigator.of(context).push(previewPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Camera(
          controller: _controller,
          placeholder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          preview: (context, preview) => CameraFrame(
            child: preview,
            onSnapPressed: _onSnapPressed,
          ),
          error: (context, error) => Center(child: Text(error.description)),
        ),
      ),
    );
  }
}

class CameraFrame extends StatelessWidget {
  const CameraFrame({
    Key? key,
    required this.onSnapPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final void Function() onSnapPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ElevatedButton(
            child: const Text('Take Photo'),
            onPressed: onSnapPressed,
          ),
        ),
      ],
    );
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  static Route route({required Uint8List image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
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

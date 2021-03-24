import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';

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

enum CameraStatus { uninitialized, ready, unavailable }

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  var _status = CameraStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() {
    _controller = CameraController()
      ..initialize().then((_) {
        setState(() => _status = CameraStatus.ready);
      }).catchError((_) {
        setState(() => _status = CameraStatus.unavailable);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSnapPressed() async {
    final file = await _controller.takePicture();
    final image = await file.readAsBytes();
    final previewPageRoute = PreviewPage.route(image: image);
    setState(() => _status = CameraStatus.uninitialized);
    await Navigator.of(context).push(previewPageRoute);
    setState(() => _status = CameraStatus.ready);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            switch (_status) {
              case CameraStatus.uninitialized:
                return const Center(child: CircularProgressIndicator());
              case CameraStatus.ready:
                return CameraFrame(
                  child: _controller.buildPreview(),
                  onSnapPressed: _onSnapPressed,
                );
              case CameraStatus.unavailable:
                return const Center(child: Text('Camera Unavailable'));
            }
          },
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

import 'dart:typed_data';
import 'package:camera_web/camera_web.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

class SingleCapturePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => SingleCapturePage());
  }

  @override
  _SingleCapturePageState createState() => _SingleCapturePageState();
}

enum CameraStatus { uninitialized, ready, unavailable }

class _SingleCapturePageState extends State<SingleCapturePage> {
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
    final bytes = await file.readAsBytes();
    final previewPageRoute = PreviewPage.route(bytes: bytes);
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

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.bytes}) : super(key: key);

  static Route route({required Uint8List bytes}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(bytes: bytes));
  }

  final Uint8List bytes;

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Keypoint? keypoint;

  Future<void> _analyzeImage() async {
    final pose = await TensorflowPlatform.instance
        .estimateSinglePoseFromBytes(widget.bytes);
    for (var item in pose.keypoints) {
      print(item);
    }
    setState(() {
      keypoint = pose.keypoints[5];
    });
  }

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.memory(
              Uint8List.fromList(widget.bytes),
              errorBuilder: (context, error, stackTrace) {
                return Text('Error, $error, $stackTrace');
              },
            ),
          ),
        ],
      ),
    );
  }
}

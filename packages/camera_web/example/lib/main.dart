import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum CameraStatus { uninitialized, ready, unavailable }

class _MyAppState extends State<MyApp> {
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
                return _controller.buildPreview();
              case CameraStatus.unavailable:
                return const Center(child: Text('Camera Unavailable'));
            }
          },
        ),
      ),
    );
  }
}

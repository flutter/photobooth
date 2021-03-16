import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController();
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
        body: _controller.buildPreview(),
      ),
    );
  }
}

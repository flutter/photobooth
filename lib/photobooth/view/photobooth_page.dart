import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PhotoboothPage extends StatefulWidget {
  const PhotoboothPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const PhotoboothPage());
  }

  @override
  _PhotoboothPageState createState() => _PhotoboothPageState();
}

class _PhotoboothPageState extends State<PhotoboothPage> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(
        controller: _cameraController,
        placeholder: (_) => Center(child: PhotoboothPlaceholder()),
        error: (context, error) => Center(child: PhotoboothError(error: error)),
      ),
    );
  }
}

class PhotoboothPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const CircularProgressIndicator();
}

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({Key? key, required this.error}) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    return Text(error.description);
  }
}

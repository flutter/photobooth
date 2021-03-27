import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/preview/preview.dart';

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
    _cameraController = CameraController()..start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onSnapPressed() async {
    final image = await _cameraController.takePicture();
    final previewPageRoute = PreviewPage.route(image: image);
    _cameraController.stop();
    await Navigator.of(context).push(previewPageRoute);
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(
        controller: _cameraController,
        placeholder: (_) => Center(child: PhotoboothPlaceholder()),
        preview: (context, preview) => PhotoboothPreview(
          preview: preview,
          onSnapPressed: _onSnapPressed,
        ),
        error: (context, error) => Center(child: PhotoboothError(error: error)),
      ),
    );
  }
}

class PhotoboothPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const CircularProgressIndicator();
}

class PhotoboothPreview extends StatelessWidget {
  const PhotoboothPreview({
    Key? key,
    required this.preview,
    required this.onSnapPressed,
  }) : super(key: key);

  final Widget preview;
  final VoidCallback onSnapPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        preview,
        Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            child: const Icon(Icons.photo_camera),
            onPressed: onSnapPressed,
          ),
        ),
      ],
    );
  }
}

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({Key? key, required this.error}) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    return Text(error.description);
  }
}

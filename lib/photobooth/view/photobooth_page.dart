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
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() async {
    _controller = CameraController();
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoboothView(controller: _controller),
    );
  }
}

class PhotoboothView extends StatelessWidget {
  const PhotoboothView({Key? key, required this.controller}) : super(key: key);

  final CameraController controller;

  void _onSnapPressed(BuildContext context) async {
    final image = await controller.takePicture();
    final previewPageRoute = PreviewPage.route(image: image.data);
    await controller.stop();
    await Navigator.of(context).push(previewPageRoute);
    await controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Camera(
      controller: controller,
      placeholder: (_) => Center(child: PhotoboothPlaceholder()),
      preview: (context, preview) => PhotoboothPreview(
        preview: preview,
        onSnapPressed: () => _onSnapPressed(context),
      ),
      error: (context, error) => Center(child: PhotoboothError(error: error)),
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
            key: const Key('photoboothPreview_photo_floatingActionButton'),
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

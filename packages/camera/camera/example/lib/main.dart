import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

const _cameraOptions = CameraOptions(audio: AudioConstraints(enabled: false));

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() async {
    _controller = CameraController(options: _cameraOptions);
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSnapPressed() async {
    final image = await _controller.takePicture();
    final previewPageRoute = PreviewPage.route(image: image.data);
    await _controller.stop();
    await Navigator.of(context).push(previewPageRoute);
    await _controller.play();
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
            onSnapPressed: _onSnapPressed,
            child: preview,
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
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: onSnapPressed,
            child: const Text('Take Photo'),
          ),
        ),
      ],
    );
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  static Route route({required String image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: Image.network(
          image,
          errorBuilder: (context, error, stackTrace) {
            return Text('Error, $error, $stackTrace');
          },
        ),
      ),
    );
  }
}

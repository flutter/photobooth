import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;
import 'package:tensorflow_models/tensorflow_models.dart' as tf_models;

const _posenetConfig = tf_models.ModelConfig(
  architecture: 'MobileNetV1',
  outputStride: 16,
  inputResolution: 257,
  multiplier: 0.5,
  quantBytes: 2,
);
const _poseConfig = tf_models.SinglePersonInterfaceConfig(
  flipHorizontal: false,
);
const _minPoseConfidence = 0.1;
const _minPartConfidence = 0.5;
const _supportedParts = ['leftShoulder', 'rightShoulder'];

class PhotoboothPage extends StatefulWidget {
  PhotoboothPage({
    Key? key,
    CameraController? controller,
    ValueGetter<Future<posenet.PoseNet>>? loadPoseNet,
  })  : controller = controller ?? CameraController(),
        loadPoseNet = (loadPoseNet ?? () => posenet.load(_posenetConfig)),
        super(key: key);

  final CameraController controller;
  final ValueGetter<Future<posenet.PoseNet>> loadPoseNet;

  static Route route() => MaterialPageRoute(builder: (_) => PhotoboothPage());

  @override
  _PhotoboothPageState createState() => _PhotoboothPageState();
}

class _PhotoboothPageState extends State<PhotoboothPage> {
  CameraController get _controller => widget.controller;
  StreamSubscription<CameraImage>? _subscription;
  posenet.PoseNet? _net;
  CameraImage? _image;
  posenet.Pose? _pose;
  ui.Image? _dash;

  @override
  void initState() {
    super.initState();
    Future.wait([
      _initializePoseNet(),
      _initializeAssets(),
      _initializeCameraController(),
    ]).then((_) {
      _subscription = _controller.imageStream.listen(_onImage);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _net?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    await _controller.initialize();
    await _controller.play();
  }

  Future<void> _initializePoseNet() async {
    _net = await widget.loadPoseNet();
  }

  Future<void> _initializeAssets() async {
    final data = await rootBundle.load('assets/images/dash.png');
    final image = await decodeImageFromList(Uint8List.view(data.buffer));
    _dash = image;
  }

  void _onImage(CameraImage image) async {
    _pose = await _net?.estimateSinglePose(
      tf_models.ImageData(
        data: Uint8ClampedList.fromList(image.imageData.data),
        width: image.imageData.width,
        height: image.imageData.height,
      ),
      config: _poseConfig,
    );
    _image = image;
    if (_pose != null && _dash != null && mounted) setState(() {});
  }

  void _onSnapPressed() async {
    final image = await widget.controller.takePicture();
    final previewPageRoute = PreviewPage.route(image: image);
    _subscription?.pause();
    await widget.controller.stop();
    await Navigator.of(context).push(previewPageRoute);
    _subscription?.resume();
    await widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    final pose = _pose;
    final dash = _dash;
    return Scaffold(
      body: Camera(
        controller: widget.controller,
        placeholder: (_) => Center(child: PhotoboothPlaceholder()),
        preview: (context, preview) {
          return PhotoboothPreview(
            preview: Stack(
              fit: StackFit.expand,
              children: [
                preview,
                if (image != null && pose != null && dash != null)
                  CustomPaint(
                    key: const Key('photoboothView_posePainter_customPainter'),
                    size: Size(image.width.toDouble(), image.height.toDouble()),
                    painter: PosePainter(pose: pose, image: dash),
                  ),
              ],
            ),
            onSnapPressed: _onSnapPressed,
          );
        },
        error: (_, error) => Center(child: PhotoboothError(error: error)),
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

class PosePainter extends CustomPainter {
  const PosePainter({required this.pose, required this.image});

  final posenet.Pose pose;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    if (pose.score < _minPoseConfidence) return;
    for (final keypoint in pose.keypoints) {
      if (!_supportedParts.contains(keypoint.part)) continue;
      if (keypoint.score < _minPartConfidence) continue;
      final x = keypoint.position.x.ceilToDouble();
      final y = keypoint.position.y.ceilToDouble();
      final offset = Offset(x, y);
      final normalizedOffset = Offset(
        offset.dx - image.width / 2,
        (offset.dy - image.height) - 50,
      );
      canvas.drawImage(image, normalizedOffset, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.pose.score != pose.score;
  }
}

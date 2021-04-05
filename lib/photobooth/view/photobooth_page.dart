import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/photobooth/widgets/photobooth_placeholder.dart';
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
  const PhotoboothPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const PhotoboothPage());
  }

  @override
  _PhotoboothPageState createState() => _PhotoboothPageState();
}

class _PhotoboothPageState extends State<PhotoboothPage> {
  final _controller = CameraController(
    options: const CameraOptions(
      audio: AudioConstraints(enabled: false),
      video: VideoConstraints(height: 1024, width: 1024),
    ),
  );
  StreamSubscription<CameraImage>? _subscription;
  posenet.PoseNet? _net;
  CameraImage? _image;
  posenet.Pose? _pose;

  @override
  void initState() {
    super.initState();
    Future.wait([
      _initializePoseNet(),
      _initializeCameraController(),
    ]).then((_) {
      _subscription = _controller.imageStream.listen(_onImage);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    _net?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    await _controller.initialize();
    await _controller.play();
  }

  Future<void> _initializePoseNet() async {
    _net = await posenet.load(_posenetConfig);
  }

  void _onImage(CameraImage image) async {
    _pose = await _net?.estimateSinglePose(
      tf_models.ImageData(
        data: Uint8ClampedList.fromList(image.raw.data),
        width: image.raw.width,
        height: image.raw.height,
      ),
      config: _poseConfig,
    );
    _image = image;
    if (_pose != null && mounted) setState(() {});
  }

  void _onSnapPressed() async {
    final picture = await _controller.takePicture();
    final image = await _composite(picture, _pose);
    final previewPageRoute = PreviewPage.route(image: image);
    _subscription?.pause();
    await _controller.stop();
    await Navigator.of(context).push(previewPageRoute);
    _subscription?.resume();
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    final pose = _pose;
    return Scaffold(
      body: Camera(
        controller: _controller,
        placeholder: (_) => const PhotoboothPlaceholder(),
        preview: (context, preview) {
          return PhotoboothPreview(
            preview: Stack(
              fit: StackFit.expand,
              children: [
                preview,
                if (image != null && pose != null)
                  CustomPaint(
                    key: const Key('photoboothView_posePainter_customPainter'),
                    size: Size(image.width.toDouble(), image.height.toDouble()),
                    painter: PosePainter(pose: pose, image: Assets.dash.image),
                  ),
              ],
            ),
            onSnapPressed: _onSnapPressed,
          );
        },
        error: (_, error) => PhotoboothError(error: error),
      ),
    );
  }
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

class PosePainter extends CustomPainter {
  const PosePainter({required this.pose, required this.image});

  final posenet.Pose pose;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final positions = _computePositions(pose: pose, image: image);
    for (final position in positions) {
      canvas.drawImage(image, position, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.pose.score != pose.score;
  }
}

List<Offset> _computePositions({
  required ui.Image image,
  posenet.Pose? pose,
  Size scale = const Size(1.0, 1.0),
}) {
  final positions = <Offset>[];
  final _pose = pose;
  if (_pose == null) return positions;
  if (_pose.score < _minPoseConfidence) return positions;
  for (final keypoint in _pose.keypoints) {
    if (!_supportedParts.contains(keypoint.part)) continue;
    if (keypoint.score < _minPartConfidence) continue;
    final x = keypoint.position.x.ceilToDouble();
    final y = keypoint.position.y.ceilToDouble();
    final offset = Offset(x * scale.width, y * scale.height);
    final normalizedOffset = Offset(
      (offset.dx - image.width / 2),
      ((offset.dy - image.height) - 50),
    );
    positions.add(normalizedOffset);
  }
  return positions;
}

Future<ImageData> _composite(CameraImage picture, posenet.Pose? pose) async {
  final xScale = picture.thumbnail.width / picture.raw.width;
  final yScale = picture.thumbnail.height / picture.raw.height;
  final scale = Size(xScale, yScale);
  final positions = _computePositions(
    pose: pose,
    image: Assets.dash.image,
    scale: scale,
  );
  final dashImage = img.Image.fromBytes(
    Assets.dash.image.width,
    Assets.dash.image.height,
    Uint8List.view(Assets.dash.buffer),
  );
  final rawImage = img.Image.fromBytes(
    picture.raw.width,
    picture.raw.height,
    picture.raw.data,
  );

  var modifiedImage = img.copyResize(
    rawImage,
    height: picture.thumbnail.height,
    width: picture.thumbnail.width,
    interpolation: img.Interpolation.average,
  );

  for (final position in positions) {
    modifiedImage = img.drawImage(
      modifiedImage,
      dashImage,
      dstX: position.dx.round(),
      dstY: position.dy.round(),
    );
  }

  final data = Uint8List.fromList(img.encodePng(modifiedImage));
  return ImageData(
    data: data,
    width: picture.raw.width,
    height: picture.raw.height,
  );
}

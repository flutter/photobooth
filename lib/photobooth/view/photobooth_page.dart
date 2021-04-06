import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/decoration/decoration.dart';
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

class PhotoboothPage extends StatefulWidget {
  const PhotoboothPage({Key? key, this.enablePoseDetection = false})
      : super(key: key);

  final bool enablePoseDetection;

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
      if (widget.enablePoseDetection) _initializePoseNet(),
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
    if (widget.enablePoseDetection) {
      _pose = await _net?.estimateSinglePose(
        tf_models.ImageData(
          data: Uint8ClampedList.fromList(image.raw.data),
          width: image.raw.width,
          height: image.raw.height,
        ),
        config: _poseConfig,
      );
    }
    _image = image;
    if (_pose != null && mounted) setState(() {});
  }

  void _onSnapPressed() async {
    final picture = await _controller.takePicture();
    final image = await _composite(picture, _pose);
    final decorationPageRoute = DecorationPage.route(image: image);
    _subscription?.pause();
    await _controller.stop();
    await Navigator.of(context).push(decorationPageRoute);
    _subscription?.resume();
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(
        controller: _controller,
        placeholder: (_) => const PhotoboothPlaceholder(),
        preview: (context, preview) {
          return PhotoboothPreview(
            image: _image,
            pose: _pose,
            preview: preview,
            onSnapPressed: _onSnapPressed,
          );
        },
        error: (_, error) => PhotoboothError(error: error),
      ),
    );
  }
}

Future<ImageData> _composite(CameraImage picture, posenet.Pose? pose) async {
  final xScale = picture.thumbnail.width / picture.raw.width;
  final yScale = picture.thumbnail.height / picture.raw.height;
  final scale = Size(xScale, yScale);
  final positions = pose != null
      ? pose.toPositions(image: Assets.dash.image, scale: scale)
      : const <Offset>[];
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

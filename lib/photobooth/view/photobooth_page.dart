import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
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

class PhotoboothPage extends StatelessWidget {
  const PhotoboothPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const PhotoboothPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoboothBloc(),
      child: const PhotoboothView(),
    );
  }
}

class PhotoboothView extends StatefulWidget {
  const PhotoboothView({Key? key, this.enablePoseDetection = false})
      : super(key: key);

  final bool enablePoseDetection;

  @override
  _PhotoboothViewState createState() => _PhotoboothViewState();
}

class _PhotoboothViewState extends State<PhotoboothView> {
  final _controller = CameraController(
    options: CameraOptions(
      audio: const AudioConstraints(enabled: false),
      video: isMobile
          ? const VideoConstraints(width: 3072, height: 4096)
          : const VideoConstraints(width: 4096, height: 3072),
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
    final decorationPageRoute = DecorationPage.route(image: picture.thumbnail);
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

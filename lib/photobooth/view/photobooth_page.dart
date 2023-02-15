import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _videoConstraints = VideoConstraints(
  facingMode: FacingMode(
    type: CameraType.user,
    constrain: Constrain.ideal,
  ),
  width: VideoSize(ideal: 1920, maximum: 1920),
  height: VideoSize(ideal: 1080, maximum: 1080),
);

class PhotoboothPage extends StatelessWidget {
  const PhotoboothPage({super.key});

  static Route<void> route() {
    return AppPageRoute(builder: (_) => const PhotoboothPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoboothBloc(),
      child: Navigator(
        onGenerateRoute: (_) => AppPageRoute(
          builder: (_) => const PhotoboothView(),
        ),
      ),
    );
  }
}

class PhotoboothView extends StatefulWidget {
  const PhotoboothView({super.key});

  @override
  State<PhotoboothView> createState() => _PhotoboothViewState();
}

class _PhotoboothViewState extends State<PhotoboothView> {
  final _controller = CameraController(
    options: const CameraOptions(
      audio: AudioConstraints(),
      video: _videoConstraints,
    ),
  );

  bool get _isCameraAvailable =>
      _controller.value.status == CameraStatus.available;

  Future<void> _play() async {
    if (!_isCameraAvailable) return;
    return _controller.play();
  }

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller.stop();
  }

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    await _controller.initialize();
    await _play();
  }

  Future<void> _onSnapPressed({required double aspectRatio}) async {
    final navigator = Navigator.of(context);
    final photoboothBloc = context.read<PhotoboothBloc>();
    final picture = await _controller.takePicture();
    photoboothBloc.add(PhotoCaptured(aspectRatio: aspectRatio, image: picture));
    final stickersPage = StickersPage.route();
    await _stop();
    unawaited(navigator.pushReplacement(stickersPage));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? PhotoboothAspectRatio.portrait
        : PhotoboothAspectRatio.landscape;
    return Scaffold(
      body: _PhotoboothBackground(
        aspectRatio: aspectRatio,
        child: Camera(
          controller: _controller,
          placeholder: (_) => const SizedBox(),
          preview: (context, preview) => PhotoboothPreview(
            preview: preview,
            onSnapPressed: () => _onSnapPressed(aspectRatio: aspectRatio),
          ),
          error: (context, error) => PhotoboothError(error: error),
        ),
      ),
    );
  }
}

class _PhotoboothBackground extends StatelessWidget {
  const _PhotoboothBackground({
    required this.aspectRatio,
    required this.child,
  });

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PhotoboothBackground(),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ColoredBox(
              color: PhotoboothColors.black,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

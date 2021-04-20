import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import 'package:io_photobooth/stickers/stickers.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class PhotoboothPage extends StatelessWidget {
  const PhotoboothPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const PhotoboothPage());
  }

  static const String name = 'PhotoboothPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoboothBloc(),
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const PhotoboothView(),
          settings: const RouteSettings(name: name),
        ),
      ),
    );
  }
}

class PhotoboothView extends StatefulWidget {
  const PhotoboothView({Key? key}) : super(key: key);

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
    await _controller.play();
  }

  void _onSnapPressed() async {
    final picture = await _controller.takePicture();
    context.read<PhotoboothBloc>().add(PhotoCaptured(image: picture));
    final stickersPage = StickersPage.route();
    await _controller.stop();
    await Navigator.of(context).push(stickersPage);
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/wood_background.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Center(
            child: Camera(
              controller: _controller,
              placeholder: (_) => const PhotoboothPlaceholder(),
              preview: (context, preview) {
                return ResponsiveLayoutBuilder(
                  mobile: (_) => AspectRatio(
                    aspectRatio: 3 / 4,
                    child: PhotoboothPreview(
                      preview: preview,
                      onSnapPressed: _onSnapPressed,
                    ),
                  ),
                  desktop: (_) => AspectRatio(
                    aspectRatio: 4 / 3,
                    child: PhotoboothPreview(
                      preview: preview,
                      onSnapPressed: _onSnapPressed,
                    ),
                  ),
                );
              },
              error: (_, error) => PhotoboothError(error: error),
            ),
          ),
        ],
      ),
    );
  }
}

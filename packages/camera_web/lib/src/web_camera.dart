import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class WebCamera {
  WebCamera(this.cameraId, {html.Window? window})
      : _videoElement = html.VideoElement(),
        window = window ?? html.window {
    ui.platformViewRegistry.registerViewFactory(
      'camera-$cameraId',
      (_) => _videoElement,
    );
  }

  final int cameraId;
  final html.VideoElement _videoElement;
  final html.Window window;

  bool get isSupported => window.navigator.mediaDevices != null;

  Future<html.MediaStream> getPreview({bool video = true}) {
    if (!isSupported) throw UnsupportedError('camera unavailable');
    return window.navigator.mediaDevices!.getUserMedia({'video': video});
  }

  Widget buildPreview() {
    if (!isSupported) return const SizedBox();

    getPreview().then((stream) {
      _videoElement
        ..autoplay = true
        ..srcObject = stream;
    });

    return _Disposable(
      child: HtmlElementView(viewType: 'camera-$cameraId'),
      onDispose: stopPreview,
    );
  }

  void stopPreview() {
    final tracks = _videoElement.srcObject?.getVideoTracks();
    if (tracks != null) {
      for (final track in tracks) {
        track.stop();
      }
    }
    _videoElement
      ..srcObject = null
      ..load();
  }

  Future<String> takePicture() async {
    final widthPx = _videoElement.style.width;
    final heightPx = _videoElement.style.height;

    final width = widthPx.contains('px')
        ? int.tryParse(widthPx.split('px').first) ?? 0
        : 0;
    final height = heightPx.contains('px')
        ? int.tryParse(heightPx.split('px').first) ?? 0
        : 0;
    final canvas = html.CanvasElement(width: width, height: height);
    canvas.context2D
        .drawImageScaled(_videoElement, 0, 0, canvas.width!, canvas.height!);
    return canvas.toDataUrl();
  }
}

class _Disposable extends StatefulWidget {
  const _Disposable({
    Key? key,
    required this.onDispose,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final void Function() onDispose;

  @override
  _DisposableState createState() => _DisposableState();
}

class _DisposableState extends State<_Disposable> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }
}

import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const _defaultCameraOptions = {'video': true};
const _videoElementViewType = '__videoElement__';

class CameraPreview extends StatelessWidget {
  const CameraPreview({
    Key? key,
    required this.cameraId,
    this.isDebugMode = kDebugMode,
  }) : super(key: key);

  final int cameraId;
  final bool isDebugMode;

  @override
  Widget build(BuildContext context) {
    return isDebugMode
        ? const Placeholder()
        : _CameraPreview(cameraId: cameraId);
  }
}

class _CameraPreview extends StatefulWidget {
  const _CameraPreview({Key? key, required this.cameraId}) : super(key: key);
  final int cameraId;

  @override
  _CameraPreviewState createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<_CameraPreview> {
  late Widget _videoPreview;
  late VideoElement _videoElement;

  @override
  void initState() {
    super.initState();
    _videoElement = VideoElement();
    ui.platformViewRegistry.registerViewFactory(
      _videoElementViewType,
      (_) => _videoElement,
    );
    _videoPreview = HtmlElementView(
      key: UniqueKey(),
      viewType: _videoElementViewType,
    );
    final mediaDevices = window.navigator.mediaDevices;
    if (mediaDevices != null) {
      mediaDevices.getUserMedia(_defaultCameraOptions).then((stream) {
        _videoElement
          ..autoplay = true
          ..srcObject = stream;
      });
    }
  }

  @override
  Widget build(BuildContext context) => _videoPreview;
}

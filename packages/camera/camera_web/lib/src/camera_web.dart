import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_web/src/camera_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';

String _getViewType(int cameraId) => 'plugins.flutter.io/camera_$cameraId';

/// The web implementation of [CameraPlatform].
///
/// This class implements the `package:camera` functionality for the web.
class CameraPlugin extends CameraPlatform {
  /// Registers this class as the default instance of [CameraPlatform].
  static void registerWith(Registrar registrar) {
    CameraPlatform.instance = CameraPlugin();
  }

  final _cameras = <int, Camera>{};
  var _textureCounter = 1;

  @visibleForTesting
  html.Window? window;

  @override
  Future<void> init() async {
    _disposeAllCameras();
  }

  @override
  Future<void> dispose(int textureId) async {
    _cameras[textureId]!.dispose();
    _cameras.remove(textureId);
  }

  @override
  Future<int> create(CameraOptions options) async {
    final textureId = _textureCounter;
    _textureCounter++;

    final camera = Camera(
      options: options,
      textureId: textureId,
      window: window,
    );
    await camera.initialize();

    _cameras[textureId] = camera;
    return textureId;
  }

  @override
  Widget buildView(int textureId) {
    return HtmlElementView(viewType: _getViewType(textureId));
  }

  @override
  Future<void> play(int textureId) => _cameras[textureId]!.play();

  @override
  Future<void> stop(int textureId) async => _cameras[textureId]!.stop();

  @override
  Future<CameraImage> takePicture(int textureId) {
    return _cameras[textureId]!.takePicture();
  }

  @override
  Stream<CameraImage> imageStream(int textureId) {
    return _cameras[textureId]!._imageStreamController.stream;
  }

  void _disposeAllCameras() {
    for (final camera in _cameras.values) {
      camera.dispose();
    }
    _cameras.clear();
  }
}

class Camera {
  Camera({
    required this.textureId,
    this.options = const CameraOptions(),
    html.Window? window,
  }) : window = window ?? html.window;

  late html.VideoElement videoElement;
  final CameraOptions options;
  final int textureId;
  final html.Window window;
  final _imageStreamController = StreamController<CameraImage>.broadcast();

  Future<void> initialize() async {
    final isSupported = window.navigator.mediaDevices?.getUserMedia != null;
    if (!isSupported) {
      throw const CameraNotSupportedException();
    }

    videoElement = html.VideoElement();
    ui.platformViewRegistry.registerViewFactory(
      _getViewType(textureId),
      (_) => videoElement,
    );

    final stream = await _getMediaStream();

    videoElement
      ..autoplay = false
      ..muted = !options.audio.enabled
      ..srcObject = stream
      ..setAttribute('playsinline', '');
  }

  Future<html.MediaStream> _getMediaStream() async {
    try {
      final constraints = options.toJson();
      return await window.navigator.mediaDevices!.getUserMedia(
        constraints,
      );
    } on html.DomException catch (e) {
      switch (e.name) {
        case 'NotFoundError':
        case 'DevicesNotFoundError':
          throw const CameraNotFoundException();
        case 'NotReadableError':
        case 'TrackStartError':
          throw const CameraNotReadableException();
        case 'OverconstrainedError':
        case 'ConstraintNotSatisfiedError':
          throw const CameraOverconstrainedException();
        case 'NotAllowedError':
        case 'PermissionDeniedError':
          throw const CameraNotAllowedException();
        case 'TypeError':
          throw const CameraTypeException();
        default:
          throw const CameraUnknownException();
      }
    } catch (_) {
      throw const CameraUnknownException();
    }
  }

  bool get _isPlaying => !videoElement.paused;

  void _onAnimationFrame([num? _]) async {
    if (_imageStreamController.isClosed) return;
    final image = await takePicture();
    _imageStreamController.add(image);
    if (_isPlaying) window.requestAnimationFrame(_onAnimationFrame);
  }

  Future<void> play() async {
    if (videoElement.srcObject == null) {
      final stream = await _getMediaStream();
      videoElement.srcObject = stream;
    }
    await videoElement.play();
    _onAnimationFrame();
  }

  void stop() {
    final tracks = videoElement.srcObject?.getVideoTracks();
    if (tracks != null) {
      for (final track in tracks) {
        track.stop();
      }
    }
    videoElement.srcObject = null;
  }

  void dispose() {
    stop();
    videoElement
      ..srcObject = null
      ..load();
    _imageStreamController.close();
  }

  Future<CameraImage> takePicture() async {
    final videoWidth = videoElement.videoWidth;
    final videoHeight = videoElement.videoHeight;
    final widthPx = videoElement.style.width.split('px');
    final heightPx = videoElement.style.height.split('px');
    final widthString = widthPx.isNotEmpty ? widthPx.first : '$videoWidth';
    final heightString = heightPx.isNotEmpty ? heightPx.first : '$videoHeight';
    final width = int.tryParse(widthString) ?? videoWidth;
    final height = int.tryParse(heightString) ?? videoHeight;
    final canvas = html.CanvasElement(width: width, height: height);
    final previewCanvas = html.CanvasElement(
      width: videoWidth,
      height: videoHeight,
    );
    canvas.context2D.drawImageScaled(videoElement, 0, 0, width, height);
    final imageData = canvas.context2D.getImageData(0, 0, width, height);
    previewCanvas.context2D
        .drawImageScaled(videoElement, 0, 0, videoWidth, videoHeight);
    final decoded = base64.decode(previewCanvas.toDataUrl().split(',')[1]);
    return CameraImage(
      imageData: ImageData(
        data: Uint8List.fromList(imageData.data),
        decoded: decoded,
        width: imageData.width,
        height: imageData.height,
      ),
      width: width,
      height: height,
    );
  }
}

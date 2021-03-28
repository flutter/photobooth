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

    final camera = Camera(options: options, textureId: textureId);
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
  Future<Uint8List> takePicture(int textureId) {
    return _cameras[textureId]!.takePicture();
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

  final CameraOptions options;
  final int textureId;
  late html.VideoElement videoElement;
  late html.MediaStream stream;
  final html.Window window;

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
      ..srcObject = stream
      ..setAttribute('playsinline', '');

    final width = options.video.width;
    if (width != null) {
      videoElement.width = width;
    }

    final height = options.video.height;
    if (height != null) {
      videoElement.height = height;
    }
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

  Future<void> play() async {
    if (videoElement.srcObject == null) {
      final stream = await _getMediaStream();
      videoElement.srcObject = stream;
    }
    await videoElement.play();
    videoElement.mirror();
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
  }

  Future<Uint8List> takePicture() async {
    final width = videoElement.videoWidth;
    final height = videoElement.videoHeight;
    final canvas = html.CanvasElement(width: width, height: height);
    canvas.context2D.drawImageScaled(videoElement, 0, 0, width, height);
    final dataUrl = canvas.toDataUrl();
    return base64.decode(dataUrl.split(',')[1]);
  }
}

extension on html.VideoElement {
  void mirror() {
    style
      ..removeProperty('transform-origin')
      ..setProperty('transform', 'rotateY(180deg)')
      ..setProperty('-webkit-transform', 'rotateY(180deg)')
      ..setProperty('-moz-transform', 'rotateY(180deg)');
  }
}

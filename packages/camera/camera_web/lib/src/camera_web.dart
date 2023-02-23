import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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

  void _disposeAllCameras() {
    for (final camera in _cameras.values) {
      camera.dispose();
    }
    _cameras.clear();
  }

  @override
  Future<List<MediaDeviceInfo>> getMediaDevices() async {
    final videoDevices = <MediaDeviceInfo>[];
    if (html.window.navigator.mediaDevices != null) {
      final devices =
          await html.window.navigator.mediaDevices?.enumerateDevices() ?? [];
      for (var deviceIndex = 0; deviceIndex < devices.length; deviceIndex++) {
        final device = devices[deviceIndex];
        if (device is html.MediaDeviceInfo && device.kind == 'videoinput') {
          videoDevices.add(
            MediaDeviceInfo(
              deviceId: device.deviceId,
              label: device.label,
            ),
          );
        }
      }
    }
    return videoDevices;
  }

  @override
  Future<String?> getDefaultDeviceId() async {
    String? defaultId = VideoConstraints.defaultDeviceId;
    if (browserEngine != BrowserEngine.blink) {
      /// For browsers other than Chrome, enumerate video devices and return
      /// first one since it is the default selected for the browser.
      final devices = await getMediaDevices();
      if (devices.isNotEmpty) {
        defaultId = devices[0].deviceId;
      }
    }
    return defaultId;
  }
}

class Camera {
  Camera({
    required this.textureId,
    this.options = const CameraOptions(),
    html.Window? window,
  }) : window = window ?? html.window;

  late html.VideoElement videoElement;
  late html.DivElement divElement;
  final CameraOptions options;
  final int textureId;
  final html.Window window;

  Future<void> initialize() async {
    final isSupported = window.navigator.mediaDevices?.getUserMedia != null;
    if (!isSupported) {
      throw const CameraNotSupportedException();
    }

    videoElement = html.VideoElement()..applyDefaultStyles();
    divElement = html.DivElement()
      ..style.setProperty('object-fit', 'cover')
      ..append(videoElement);
    // ignore: avoid_dynamic_calls
    ui.platformViewRegistry.registerViewFactory(
      _getViewType(textureId),
      (_) => divElement,
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
      final constraints = await options.toJson();
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

  Future<CameraImage> takePicture() async {
    final videoWidth = videoElement.videoWidth;
    final videoHeight = videoElement.videoHeight;
    final canvas = html.CanvasElement(width: videoWidth, height: videoHeight);
    canvas.context2D
      ..translate(videoWidth, 0)
      ..scale(-1, 1)
      ..drawImageScaled(videoElement, 0, 0, videoWidth, videoHeight);
    final blob = await canvas.toBlob();
    return CameraImage(
      data: html.Url.createObjectUrl(blob),
      width: videoWidth,
      height: videoHeight,
    );
  }
}

extension on html.VideoElement {
  void applyDefaultStyles() {
    style
      ..removeProperty('transform-origin')
      ..setProperty('pointer-events', 'none')
      ..setProperty('width', '100%')
      ..setProperty('height', '100%')
      ..setProperty('transform', 'scaleX(-1)')
      ..setProperty('object-fit', 'cover')
      ..setProperty('-webkit-transform', 'scaleX(-1)')
      ..setProperty('-moz-transform', 'scaleX(-1)');
  }
}

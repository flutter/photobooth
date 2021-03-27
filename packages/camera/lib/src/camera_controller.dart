import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'camera.dart';
part 'camera_options.dart';

String _getViewType(String cameraId) => 'plugins.flutter.io/camera_$cameraId';

enum CameraStatus { uninitialized, available, unavailable }

class CameraState {
  const CameraState._({
    this.status = CameraStatus.uninitialized,
    this.error,
  });

  const CameraState.uninitialized() : this._();
  const CameraState.available() : this._(status: CameraStatus.available);
  const CameraState.unavailable(CameraException error)
      : this._(status: CameraStatus.unavailable, error: error);

  final CameraStatus status;
  final CameraException? error;
}

class CameraController extends ValueNotifier<CameraState> {
  CameraController({
    this.options = const CameraOptions(),
    html.Window? window,
  })  : window = window ?? html.window,
        super(const CameraState.uninitialized());

  final CameraOptions options;
  String? _cameraId;
  String get cameraId {
    final id = _cameraId;
    if (id != null) return id;
    throw StateError(
      '''cameraId called without a camera stream. Did you forget to call start()?''',
    );
  }

  html.VideoElement? _videoElement;
  html.MediaStream? _stream;

  html.VideoElement get _video {
    final video = _videoElement;
    if (video != null) return video;
    throw StateError(
      '''takePicture called without a camera stream. Did you forget to call start()?''',
    );
  }

  final html.Window window;

  void start() async {
    if (value.status != CameraStatus.uninitialized) {
      throw StateError('cannot call start multiple times');
    }

    final isSupported = window.navigator.mediaDevices?.getUserMedia != null;
    if (!isSupported) {
      value = const CameraState.unavailable(CameraNotSupportedException());
      return;
    }

    try {
      final constraints = options.toJson();
      _stream = await window.navigator.mediaDevices!.getUserMedia(
        constraints,
      );
      _videoElement = html.VideoElement();
      _cameraId = const Uuid().v4();
      ui.platformViewRegistry.registerViewFactory(
        _getViewType(_cameraId!),
        (_) => _video,
      );
      _video
        ..autoplay = true
        ..setAttribute('playsinline', '')
        ..srcObject = _stream;

      final width = options.video.width;
      if (width != null) {
        _video.width = width;
      }
      final height = options.video.height;
      if (height != null) {
        _video.height = height;
      }

      value = const CameraState.available();
    } on html.DomException catch (e) {
      late CameraException error;
      switch (e.name) {
        case 'NotFoundError':
        case 'DevicesNotFoundError':
          error = const CameraNotFoundException();
          break;
        case 'NotReadableError':
        case 'TrackStartError':
          error = const CameraNotReadableException();
          break;
        case 'OverconstrainedError':
        case 'ConstraintNotSatisfiedError':
          error = const CameraOverconstrainedException();
          break;
        case 'NotAllowedError':
        case 'PermissionDeniedError':
          error = const CameraNotAllowedException();
          break;
        case 'TypeError':
          error = const CameraTypeException();
          break;
        default:
          error = const CameraUnknownException();
          break;
      }
      value = CameraState.unavailable(error);
    } catch (_) {
      value = const CameraState.unavailable(CameraUnknownException());
    }
  }

  void stop() {
    value = const CameraState.uninitialized();
    final tracks = _videoElement?.srcObject?.getVideoTracks();
    if (tracks != null) {
      for (final track in tracks) {
        track.stop();
      }
    }
    _stream = null;
    _videoElement = null;
  }

  @override
  void dispose() {
    if (value.status != CameraStatus.uninitialized) stop();
    super.dispose();
  }

  Future<Uint8List> takePicture() async {
    final width = _video.videoWidth;
    final height = _video.videoHeight;
    final canvas = html.CanvasElement(width: width, height: height);
    canvas.context2D.drawImageScaled(_video, 0, 0, width, height);
    final dataUrl = canvas.toDataUrl();
    return base64.decode(dataUrl.split(',')[1]);
  }
}

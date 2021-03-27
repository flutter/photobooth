import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CameraOptions {
  const CameraOptions({
    AudioConstraints? audio,
    VideoConstraints? video,
  })  : audio = audio ?? const AudioConstraints(),
        video = video ?? const VideoConstraints();

  final AudioConstraints audio;
  final VideoConstraints video;

  Map<String, dynamic> toJson() {
    return {'audio': audio.toJson(), 'video': video.toJson()};
  }
}

enum CameraType { front, rear }
enum Constrain { exact, ideal }

class FacingMode {
  const FacingMode({this.constrain, this.type});
  final Constrain? constrain;
  final CameraType? type;

  Object? toJson() {
    if (constrain == null) {
      return type != null ? describeEnum(type!) : null;
    }
    return {
      describeEnum(constrain!): describeEnum(type!),
    };
  }
}

class AudioConstraints {
  const AudioConstraints({this.enabled = false});
  final bool enabled;

  Object toJson() => enabled;
}

class VideoConstraints {
  const VideoConstraints({
    this.enabled = true,
    this.facingMode,
    this.width,
    this.height,
  });

  final bool enabled;
  final FacingMode? facingMode;
  final num? width;
  final num? height;

  Object toJson() {
    if (!enabled) return false;
    final json = <String, dynamic>{};

    if (width != null) {
      json['width'] = width;
    }
    if (height != null) {
      json['height'] = height;
    }
    if (facingMode != null) {
      json['facingMode'] = facingMode!.toJson();
    }
    return json;
  }
}

abstract class CameraException implements Exception {
  CameraException(this.description);
  final String description;
}

class CameraNotSupportedException implements CameraException {
  @override
  String get description => 'Not Supported';
}

class CameraAbortException implements CameraException {
  @override
  String get description => 'Aborted';
}

class CameraNotAllowedException implements CameraException {
  @override
  String get description => 'Not Allowed';
}

class CameraNotFoundException implements CameraException {
  @override
  String get description => 'Not Found';
}

class CameraNotReadableException implements CameraException {
  @override
  String get description => 'Not Readable';
}

class CameraOverconstrainedException implements CameraException {
  @override
  String get description => 'Overconstrained';
}

class CameraSecurityException implements CameraException {
  @override
  String get description => 'Security Error';
}

class CameraTypeException implements CameraException {
  @override
  String get description => 'Type Error';
}

class CameraUnknownException implements CameraException {
  @override
  String get description => 'Unknown Error';
}

enum CameraStatus { uninitialized, available, unavailable }

class CameraState {
  const CameraState({
    this.status = CameraStatus.uninitialized,
    this.error,
  });

  final CameraStatus status;
  final CameraException? error;

  CameraState copyWith({
    CameraStatus? status,
    CameraException? error,
  }) {
    return CameraState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class CameraController extends ValueNotifier<CameraState> {
  CameraController({
    this.options = const CameraOptions(),
    html.Window? window,
  })  : window = window ?? html.window,
        super(const CameraState());

  final CameraOptions options;

  @visibleForTesting
  final html.Window window;

  html.MediaStream? _stream;

  void initialize() async {
    final isSupported = window.navigator.mediaDevices != null;
    if (!isSupported) {
      value = value.copyWith(status: CameraStatus.unavailable);
    }

    try {
      final constraints = options.toJson();
      _stream = await window.navigator.mediaDevices!.getUserMedia(constraints);
      value = value.copyWith(status: CameraStatus.available);
    } on html.DomException catch (e) {
      late CameraException error;
      switch (e.name) {
        case 'NotFoundError':
        case 'DevicesNotFoundError':
          error = CameraNotFoundException();
          break;
        case 'NotReadableError':
        case 'TrackStartError':
          error = CameraNotReadableException();
          break;
        case 'OverconstrainedError':
        case 'ConstraintNotSatisfiedError':
          error = CameraOverconstrainedException();
          break;
        case 'NotAllowedError':
        case 'PermissionDeniedError':
          error = CameraNotAllowedException();
          break;
        case 'TypeError':
          error = CameraTypeException();
          break;
        default:
          error = CameraUnknownException();
          break;
      }
      value = value.copyWith(status: CameraStatus.unavailable, error: error);
    } catch (_) {
      value = value.copyWith(
        status: CameraStatus.unavailable,
        error: CameraUnknownException(),
      );
    }
  }

  @override
  void dispose() {
    value = value.copyWith(status: CameraStatus.uninitialized);
    final tracks = _stream?.getTracks() ?? <html.MediaStreamTrack>[];
    for (final track in tracks) {
      track.stop();
    }
    _stream = null;
    super.dispose();
  }
}

typedef PlaceholderBuilder = Widget Function(BuildContext);
typedef ErrorBuilder = Widget Function(BuildContext, CameraException);

class Camera extends StatefulWidget {
  Camera({
    Key? key,
    required this.controller,
    PlaceholderBuilder? placeholder,
    ErrorBuilder? error,
  })  : placeholder = (placeholder ?? (_) => const SizedBox()),
        error = (error ?? (_, __) => const SizedBox()),
        super(key: key);

  final CameraController controller;
  final PlaceholderBuilder placeholder;
  final ErrorBuilder error;

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late String _cameraId;
  html.VideoElement? _videoElement;
  Widget? __widget;
  var _cameraState = const CameraState();

  String _getViewType() => 'plugins.flutter.io/camera_$_cameraId';

  Widget get _widget => __widget ??= HtmlElementView(viewType: _getViewType());

  @override
  void initState() {
    super.initState();
    _cameraId = const Uuid().v4();
    widget.controller.initialize();
    widget.controller.addListener(_onCameraStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCameraStateChanged);
    _stopTracks();
    super.dispose();
  }

  void _onCameraStateChanged() {
    _cameraState = widget.controller.value;
    if (_cameraState.status == CameraStatus.available) {
      _initVideo();

      _videoElement!
        ..srcObject = widget.controller._stream
        ..autoplay = true;
    }
    setState(() {});
  }

  void _stopTracks() {
    final tracks = _videoElement?.srcObject?.getVideoTracks();
    if (tracks != null) {
      for (final track in tracks) {
        track.stop();
      }
    }
    _videoElement?.srcObject = null;
    _videoElement?.load();
    _videoElement = null;
  }

  void _initVideo() {
    _stopTracks();
    _videoElement = html.VideoElement();
    ui.platformViewRegistry.registerViewFactory(
      _getViewType(),
      (_) => _videoElement!,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_cameraState.status) {
      case CameraStatus.uninitialized:
        return widget.placeholder(context);
      case CameraStatus.available:
        return _widget;
      case CameraStatus.unavailable:
        return widget.error(context, _cameraState.error!);
    }
  }
}

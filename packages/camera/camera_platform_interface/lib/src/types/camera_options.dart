import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:io_photobooth/share/share.dart';

class CameraOptions {
  const CameraOptions({
    AudioConstraints? audio,
    VideoConstraints? video,
  })  : audio = audio ?? const AudioConstraints(),
        video = video ?? const VideoConstraints();

  final AudioConstraints audio;
  final VideoConstraints video;

  Future<Map<String, dynamic>> toJson() async {
    final videoConstraints = await video.toJson();
    return {'audio': audio.toJson(), 'video': videoConstraints};
  }
}

enum CameraType { rear, user }
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
    this.deviceId,
  });

  static const String defaultDeviceId = 'default';

  final bool enabled;
  final FacingMode? facingMode;
  final int? width;
  final int? height;
  final String? deviceId;

  Future<Object> toJson() async {
    if (!enabled) return false;
    final json = <String, dynamic>{};

    if (width != null) json['width'] = width;
    if (height != null) json['height'] = height;
    if (facingMode != null) json['facingMode'] = facingMode!.toJson();
    if (deviceId == 'default' && browserEngine != BrowserEngine.blink) {
      /// For browsers other than Chrome, enumerate video devices and return
      /// first one since it is the default selected for the browser.
      final devices = await _enumerateCameras();
      if (devices.isNotEmpty) {
        json['deviceId'] = devices[0].deviceId;
      }
    } else {
      if (deviceId != null) json['deviceId'] = deviceId!;
    }
    return json;
  }
}

Future<List<html.MediaDeviceInfo>> _enumerateCameras() async {
  final videoDevices = <html.MediaDeviceInfo>[];
  if (html.window.navigator.mediaDevices != null) {
    final devices =
        await html.window.navigator.mediaDevices?.enumerateDevices() ?? [];
    for (var deviceIndex = 0; deviceIndex < devices.length; deviceIndex++) {
      dynamic device = devices[deviceIndex];
      if (device is html.MediaDeviceInfo && device.kind == 'videoinput') {
        videoDevices.add(device);
      }
    }
  }
  return videoDevices;
}
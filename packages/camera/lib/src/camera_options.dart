part of 'camera_controller.dart';

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
  final int? width;
  final int? height;

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

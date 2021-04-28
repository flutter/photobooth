export 'src/unsupported.dart' if (dart.library.html) 'src/web.dart';

class Vector2D {
  const Vector2D(this.x, this.y);

  factory Vector2D.fromJson(Map json) {
    return Vector2D(
      double.parse(json['x'] as String),
      double.parse(json['y'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'x': '$x', 'y': '$y'};
  }

  final double x;
  final double y;
}

class CompositeLayer {
  const CompositeLayer({
    required this.angle,
    required this.position,
    required this.scale,
    required this.size,
    required this.assetPath,
  });

  factory CompositeLayer.fromJson(Map json) {
    return CompositeLayer(
      angle: double.parse(json['angle'] as String),
      scale: double.parse(json['scale'] as String),
      assetPath: json['assetPath'] as String,
      position: Vector2D.fromJson(json['position'] as Map),
      size: Vector2D.fromJson(json['size'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'angle': '$angle',
      'scale': '$scale',
      'assetPath': assetPath,
      'position': position.toJson(),
      'size': size.toJson(),
    };
  }

  final double angle;
  final Vector2D position;
  final double scale;
  final Vector2D size;
  final String assetPath;
}

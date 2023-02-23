export 'src/unsupported.dart' if (dart.library.html) 'src/web.dart';

/// {@template vector_2d}
/// A 2 dimensional vector representation.
/// {@endtemplate}
class Vector2D {
  /// {@macro vector_2d}
  const Vector2D(this.x, this.y);

  /// Factory which returns a [Vector2D] based on the provided [json].
  factory Vector2D.fromJson(Map<dynamic, dynamic> json) {
    return Vector2D(
      double.parse(json['x'] as String),
      double.parse(json['y'] as String),
    );
  }

  /// Converts the current instance to a Map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'x': '$x', 'y': '$y'};
  }

  /// The x value.
  final double x;

  /// The y value.
  final double y;
}

/// {@template composite_layer}
/// A representation of a layer that can be composited.
/// {@endtemplate}
class CompositeLayer {
  /// {@macro composite_layer}
  const CompositeLayer({
    required this.angle,
    required this.assetPath,
    required this.constraints,
    required this.position,
    required this.size,
  });

  /// Factory which returns a [CompositeLayer] based on the provided [json].
  factory CompositeLayer.fromJson(Map<dynamic, dynamic> json) {
    return CompositeLayer(
      angle: double.parse(json['angle'] as String),
      assetPath: json['assetPath'] as String,
      constraints: Vector2D.fromJson(json['constraints'] as Map),
      position: Vector2D.fromJson(json['position'] as Map),
      size: Vector2D.fromJson(json['size'] as Map),
    );
  }

  /// Converts the current instance to a Map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'angle': '$angle',
      'assetPath': assetPath,
      'constraints': constraints.toJson(),
      'position': position.toJson(),
      'size': size.toJson(),
    };
  }

  /// The angle of rotation in radians.
  final double angle;

  /// The absolute path to the asset.
  final String assetPath;

  /// The constraints used to normalize the asset.
  final Vector2D constraints;

  /// The relative position of the asset.
  final Vector2D position;

  /// The size of the asset.
  final Vector2D size;
}

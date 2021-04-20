part of 'photobooth_bloc.dart';

class PhotoConstraint extends Equatable {
  const PhotoConstraint({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}

class PhotoAssetSize extends Equatable {
  const PhotoAssetSize({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object?> get props => [width, height];
}

class PhotoAssetPosition extends Equatable {
  const PhotoAssetPosition({this.dx = 0, this.dy = 0});

  final double dx;
  final double dy;

  @override
  List<Object> get props => [dx, dy];
}

class PhotoAsset extends Equatable {
  const PhotoAsset({
    required this.asset,
    this.constraint = const PhotoConstraint(),
    this.position = const PhotoAssetPosition(),
    this.size = const PhotoAssetSize(),
  });

  final Asset asset;
  final PhotoAssetPosition position;
  final PhotoAssetSize size;
  final PhotoConstraint constraint;

  @override
  List<Object> get props => [asset.name, constraint, position, size];

  PhotoAsset copyWith({
    Asset? asset,
    PhotoConstraint? constraint,
    PhotoAssetPosition? position,
    PhotoAssetSize? size,
  }) {
    return PhotoAsset(
      asset: asset ?? this.asset,
      constraint: constraint ?? this.constraint,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.characters = const <PhotoAsset>[],
    this.stickers = const <PhotoAsset>[],
    this.image,
  });

  final CameraImage? image;
  final List<PhotoAsset> characters;
  final List<PhotoAsset> stickers;

  @override
  List<Object?> get props => [image, characters, stickers];

  PhotoboothState copyWith({
    CameraImage? image,
    List<PhotoAsset>? characters,
    List<PhotoAsset>? stickers,
  }) {
    return PhotoboothState(
      image: image ?? this.image,
      characters: characters ?? this.characters,
      stickers: stickers ?? this.stickers,
    );
  }
}

extension PhotoAssetsX on List<PhotoAsset> {
  bool containsCharacter(Character character) {
    return indexWhere((e) => e.asset.name == describeEnum(character)) != -1;
  }
}

part of 'photo_bloc.dart';

class PhotoConstraint extends Equatable {
  const PhotoConstraint({this.width = 0, this.height = 0});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}

class PhotoAssetSize extends Equatable {
  const PhotoAssetSize({this.width = 0, this.height = 0});

  final double width;
  final double height;

  @override
  List<Object?> get props => [width, height];
}

class PhotoAssetPosition extends Equatable {
  const PhotoAssetPosition({required this.dx, required this.dy});

  final double dx;
  final double dy;

  @override
  List<Object> get props => [dx, dy];
}

class PhotoAsset extends Equatable {
  const PhotoAsset({
    required this.asset,
    required this.constraint,
    required this.position,
    required this.size,
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

class PhotoState extends Equatable {
  const PhotoState({
    this.characters = const <PhotoAsset>[],
    this.constraint = const PhotoConstraint(),
    this.stickers = const <PhotoAsset>[],
    this.image,
  });

  final CameraImage? image;
  final List<PhotoAsset> characters;
  final PhotoConstraint constraint;
  final List<PhotoAsset> stickers;

  @override
  List<Object?> get props => [image, characters, constraint, stickers];

  PhotoState copyWith({
    CameraImage? image,
    List<PhotoAsset>? characters,
    List<PhotoAsset>? stickers,
    PhotoConstraint? constraint,
  }) {
    return PhotoState(
      image: image ?? this.image,
      characters: characters ?? this.characters,
      constraint: constraint ?? this.constraint,
      stickers: stickers ?? this.stickers,
    );
  }
}

extension PhotoAssetsX on List<PhotoAsset> {
  bool containsCharacter(Character character) {
    return indexWhere((e) => e.asset.name == describeEnum(character)) != -1;
  }

  bool containsSticker(Sticker sticker) {
    return indexWhere((e) => e.asset.name == describeEnum(sticker)) != -1;
  }
}

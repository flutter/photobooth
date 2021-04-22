part of 'photobooth_bloc.dart';

const emptyAssetId = '';

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
    required this.id,
    required this.asset,
    this.angle = 0.0,
    this.constraint = const PhotoConstraint(),
    this.position = const PhotoAssetPosition(),
    this.scale = 1.0,
    this.size = const PhotoAssetSize(),
  });

  final String id;
  final Asset asset;
  final double angle;
  final PhotoConstraint constraint;
  final PhotoAssetPosition position;
  final double scale;
  final PhotoAssetSize size;

  @override
  List<Object> get props =>
      [id, asset.name, angle, constraint, position, scale, size];

  PhotoAsset copyWith({
    Asset? asset,
    double? angle,
    PhotoConstraint? constraint,
    PhotoAssetPosition? position,
    double? scale,
    PhotoAssetSize? size,
  }) {
    return PhotoAsset(
      id: id,
      asset: asset ?? this.asset,
      angle: angle ?? this.angle,
      constraint: constraint ?? this.constraint,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
    );
  }
}

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.characters = const <PhotoAsset>[],
    this.stickers = const <PhotoAsset>[],
    this.selectedAssetId = emptyAssetId,
    this.image,
  });

  bool get isDashSelected => characters.containsAsset(Assets.dash);

  bool get isAndroidSelected => characters.containsAsset(Assets.android);

  bool get isSparkySelected => characters.containsAsset(Assets.sparky);

  bool get isDinoSelected => characters.containsAsset(Assets.dino);

  bool get isAnyCharacterSelected => characters.isNotEmpty;

  List<PhotoAsset> get assets => characters + stickers;

  final CameraImage? image;
  final List<PhotoAsset> characters;
  final List<PhotoAsset> stickers;
  final String selectedAssetId;

  @override
  List<Object?> get props => [image, characters, stickers, selectedAssetId];

  PhotoboothState copyWith({
    CameraImage? image,
    List<PhotoAsset>? characters,
    List<PhotoAsset>? stickers,
    String? selectedAssetId,
  }) {
    return PhotoboothState(
      image: image ?? this.image,
      characters: characters ?? this.characters,
      stickers: stickers ?? this.stickers,
      selectedAssetId: selectedAssetId ?? this.selectedAssetId,
    );
  }
}

extension PhotoAssetsX on List<PhotoAsset> {
  bool containsAsset(Asset asset) {
    return indexWhere((e) => e.asset.name == asset.name) != -1;
  }
}

part of 'photobooth_bloc.dart';

const emptyAssetId = -1;

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
    this.constraint = const PhotoConstraint(),
    this.position = const PhotoAssetPosition(),
    this.size = const PhotoAssetSize(),
  });

  final int id;
  final Asset asset;
  final PhotoAssetPosition position;
  final PhotoAssetSize size;
  final PhotoConstraint constraint;

  @override
  List<Object> get props => [id, asset.name, constraint, position, size];

  PhotoAsset copyWith({
    Asset? asset,
    PhotoConstraint? constraint,
    PhotoAssetPosition? position,
    PhotoAssetSize? size,
  }) {
    return PhotoAsset(
      id: id,
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
    this.selectedAssetId = emptyAssetId,
    this.image,
  });

  final CameraImage? image;
  final List<PhotoAsset> characters;
  final List<PhotoAsset> stickers;
  final int selectedAssetId;

  @override
  List<Object?> get props => [image, characters, stickers, selectedAssetId];

  PhotoboothState copyWith({
    CameraImage? image,
    List<PhotoAsset>? characters,
    List<PhotoAsset>? stickers,
    int? selectedAssetId,
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
  bool containsCharacter(Character character) {
    return indexWhere((e) => e.asset.name == describeEnum(character)) != -1;
  }
}

extension PhotoboothStateX on PhotoboothState {
  bool get isDashSelected => characters.containsCharacter(Character.dash);

  bool get isAndroidSelected => characters.containsCharacter(Character.android);

  bool get isSparkySelected => characters.containsCharacter(Character.sparky);

  bool anyCharacterSelected() =>
      isDashSelected || isAndroidSelected || isSparkySelected;
}

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
    this.size = const PhotoAssetSize(),
  });

  final String id;
  final Asset asset;
  final double angle;
  final PhotoConstraint constraint;
  final PhotoAssetPosition position;
  final PhotoAssetSize size;

  @override
  List<Object> get props => [id, asset.name, angle, constraint, position, size];

  PhotoAsset copyWith({
    Asset? asset,
    double? angle,
    PhotoConstraint? constraint,
    PhotoAssetPosition? position,
    PhotoAssetSize? size,
  }) {
    return PhotoAsset(
      id: id,
      asset: asset ?? this.asset,
      angle: angle ?? this.angle,
      constraint: constraint ?? this.constraint,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.aspectRatio = PhotoboothAspectRatio.landscape,
    this.characters = const <PhotoAsset>[],
    this.stickers = const <PhotoAsset>[],
    this.selectedAssetId = emptyAssetId,
    this.image,
    this.imageId = '',
  });

  bool get isDashSelected => characters.containsAsset(named: 'dash');

  bool get isAndroidSelected => characters.containsAsset(named: 'android');

  bool get isSparkySelected => characters.containsAsset(named: 'sparky');

  bool get isDinoSelected => characters.containsAsset(named: 'dino');

  bool get isAnyCharacterSelected => characters.isNotEmpty;

  List<PhotoAsset> get assets => characters + stickers;

  final double aspectRatio;
  final CameraImage? image;
  final String imageId;
  final List<PhotoAsset> characters;
  final List<PhotoAsset> stickers;
  final String selectedAssetId;

  @override
  List<Object?> get props => [
        aspectRatio,
        image,
        imageId,
        characters,
        stickers,
        selectedAssetId,
      ];

  PhotoboothState copyWith({
    double? aspectRatio,
    CameraImage? image,
    String? imageId,
    List<PhotoAsset>? characters,
    List<PhotoAsset>? stickers,
    String? selectedAssetId,
  }) {
    return PhotoboothState(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      image: image ?? this.image,
      imageId: imageId ?? this.imageId,
      characters: characters ?? this.characters,
      stickers: stickers ?? this.stickers,
      selectedAssetId: selectedAssetId ?? this.selectedAssetId,
    );
  }
}

extension PhotoAssetsX on List<PhotoAsset> {
  bool containsAsset({required String named}) {
    return indexWhere((e) => e.asset.name == named) != -1;
  }
}

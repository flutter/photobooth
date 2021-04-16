part of 'photobooth_bloc.dart';

class CharacterAssetPosition extends Equatable {
  const CharacterAssetPosition({required this.dx, required this.dy});
  final double dx;
  final double dy;

  @override
  List<Object?> get props => [dx, dy];
}

class CharacterAssetSize extends Equatable {
  const CharacterAssetSize({required this.width, required this.height});
  final double width;
  final double height;

  @override
  List<Object?> get props => [width, height];
}

enum AssetType { dash, sparky, android }

class CharacterAsset extends Equatable {
  const CharacterAsset._({
    required this.type,
    this.isSelected = false,
    this.position = const CharacterAssetPosition(dx: 0, dy: 0),
    this.size = const CharacterAssetSize(width: 0, height: 0),
  });

  const CharacterAsset.dash() : this._(type: AssetType.dash);

  const CharacterAsset.sparky() : this._(type: AssetType.sparky);

  const CharacterAsset.android() : this._(type: AssetType.android);

  final AssetType type;
  final bool isSelected;
  final CharacterAssetPosition position;
  final CharacterAssetSize size;

  @override
  List<Object?> get props => [isSelected, position, size, type];

  CharacterAsset copyWith({
    bool? isSelected,
    CharacterAssetPosition? position,
    CharacterAssetSize? size,
  }) {
    return CharacterAsset._(
      type: type,
      isSelected: isSelected ?? this.isSelected,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.android = const CharacterAsset.android(),
    this.dash = const CharacterAsset.dash(),
    this.sparky = const CharacterAsset.sparky(),
  });

  final CharacterAsset android;
  final CharacterAsset dash;
  final CharacterAsset sparky;

  @override
  List<Object> get props => [android, dash, sparky];

  PhotoboothState copyWith({
    CharacterAsset? android,
    CharacterAsset? dash,
    CharacterAsset? sparky,
  }) {
    return PhotoboothState(
      android: android ?? this.android,
      dash: dash ?? this.dash,
      sparky: sparky ?? this.sparky,
    );
  }
}

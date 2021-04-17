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

class CharacterAsset extends Equatable {
  const CharacterAsset({
    this.isSelected = false,
    this.position = const CharacterAssetPosition(dx: 0, dy: 0),
    this.size = const CharacterAssetSize(width: 0, height: 0),
  });

  final bool isSelected;
  final CharacterAssetPosition position;
  final CharacterAssetSize size;

  @override
  List<Object?> get props => [isSelected, position, size];

  CharacterAsset copyWith({
    bool? isSelected,
    CharacterAssetPosition? position,
    CharacterAssetSize? size,
  }) {
    return CharacterAsset(
      isSelected: isSelected ?? this.isSelected,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.android = const CharacterAsset(),
    this.dash = const CharacterAsset(),
    this.sparky = const CharacterAsset(),
  });

  final CharacterAsset android;
  final CharacterAsset dash;
  final CharacterAsset sparky;

  @override
  List<Object?> get props => [android, dash, sparky];

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

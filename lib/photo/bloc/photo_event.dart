part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class PhotoCaptured extends PhotoEvent {
  const PhotoCaptured({required this.image});

  final CameraImage image;

  @override
  List<Object> get props => [image];
}

class PhotoConstraintsChanged extends PhotoEvent {
  const PhotoConstraintsChanged({required this.width, required this.height});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}

class PhotoCharacterToggled extends PhotoEvent {
  const PhotoCharacterToggled._({required this.character});

  const PhotoCharacterToggled.android() : this._(character: Character.android);
  const PhotoCharacterToggled.dash() : this._(character: Character.dash);
  const PhotoCharacterToggled.sparky() : this._(character: Character.sparky);

  final Character character;

  @override
  List<Object> get props => [character];
}

class PhotoCharacterDragged extends PhotoEvent {
  const PhotoCharacterDragged({required this.character, required this.update});

  final PhotoAsset character;
  final DragUpdate update;

  @override
  List<Object> get props => [character, update];
}

class PhotoStickerTapped extends PhotoEvent {
  const PhotoStickerTapped({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class PhotoStickerDragged extends PhotoEvent {
  const PhotoStickerDragged({required this.sticker, required this.update});

  final Asset sticker;
  final DragUpdate update;

  @override
  List<Object> get props => [sticker, update];
}

class PhotoClearStickersTapped extends PhotoEvent {
  const PhotoClearStickersTapped();
}

class PhotoClearAllTapped extends PhotoEvent {
  const PhotoClearAllTapped();
}

part of 'photobooth_bloc.dart';

abstract class PhotoboothEvent extends Equatable {
  const PhotoboothEvent();

  @override
  List<Object> get props => [];
}

class PhotoCaptured extends PhotoboothEvent {
  const PhotoCaptured({required this.aspectRatio, required this.image});

  final double aspectRatio;
  final CameraImage image;

  @override
  List<Object> get props => [aspectRatio, image];
}

class PhotoCharacterToggled extends PhotoboothEvent {
  const PhotoCharacterToggled({required this.character});

  final Asset character;

  @override
  List<Object> get props => [character];
}

class PhotoCharacterDragged extends PhotoboothEvent {
  const PhotoCharacterDragged({required this.character, required this.update});

  final PhotoAsset character;
  final DragUpdate update;

  @override
  List<Object> get props => [character, update];
}

class PhotoStickerTapped extends PhotoboothEvent {
  const PhotoStickerTapped({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class PhotoStickerDragged extends PhotoboothEvent {
  const PhotoStickerDragged({required this.sticker, required this.update});

  final PhotoAsset sticker;
  final DragUpdate update;

  @override
  List<Object> get props => [sticker, update];
}

class PhotoClearStickersTapped extends PhotoboothEvent {
  const PhotoClearStickersTapped();
}

class PhotoClearAllTapped extends PhotoboothEvent {
  const PhotoClearAllTapped();
}

class PhotoDeleteSelectedStickerTapped extends PhotoboothEvent {
  const PhotoDeleteSelectedStickerTapped();
}

class PhotoTapped extends PhotoboothEvent {
  const PhotoTapped();
}

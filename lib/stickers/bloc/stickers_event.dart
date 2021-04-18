part of 'stickers_bloc.dart';

abstract class StickersEvent extends Equatable {
  const StickersEvent();

  @override
  List<Object> get props => [];
}

class StickersModeToggled extends StickersEvent {
  const StickersModeToggled();
}

class StickerSelected extends StickersEvent {
  const StickerSelected({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class StickersCleared extends StickersEvent {
  const StickersCleared();
}

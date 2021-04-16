part of 'decoration_bloc.dart';

abstract class DecorationEvent extends Equatable {
  const DecorationEvent();

  @override
  List<Object?> get props => [];
}

class DecorationModeToggled extends DecorationEvent {
  const DecorationModeToggled();
}

class DecorationStickerSelected extends DecorationEvent {
  const DecorationStickerSelected({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class DecorationStickersCleared extends DecorationEvent {
  const DecorationStickersCleared();

  @override
  List<Object> get props => [];
}

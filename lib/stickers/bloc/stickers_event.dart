part of 'stickers_bloc.dart';

abstract class StickersEvent extends Equatable {
  const StickersEvent();

  @override
  List<Object> get props => [];
}

class StickersDrawerToggled extends StickersEvent {
  const StickersDrawerToggled();
}

class StickersDrawerTabSelected extends StickersEvent {
  const StickersDrawerTabSelected({required this.tabSelected});

  final int tabSelected;
}

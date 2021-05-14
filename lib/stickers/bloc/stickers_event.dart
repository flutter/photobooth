part of 'stickers_bloc.dart';

abstract class StickersEvent extends Equatable {
  const StickersEvent();

  @override
  List<Object> get props => [];
}

class StickersDrawerToggled extends StickersEvent {
  const StickersDrawerToggled();
}

class StickersDrawerTabTapped extends StickersEvent {
  const StickersDrawerTabTapped({required this.index});

  final int index;
}

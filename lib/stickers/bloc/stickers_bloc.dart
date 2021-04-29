import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stickers_event.dart';
part 'stickers_state.dart';

class StickersBloc extends Bloc<StickersEvent, StickersState> {
  StickersBloc() : super(const StickersState());

  @override
  Stream<StickersState> mapEventToState(StickersEvent event) async* {
    if (event is StickersDrawerToggled) {
      yield _mapStickersDrawerToggledToState(state);
    } else if (event is StickersClearTooltipShowed) {
      yield state.copyWith(displayClearStickersTooltip: false);
    }
  }

  StickersState _mapStickersDrawerToggledToState(StickersState state) {
    return state.copyWith(isDrawerActive: !state.isDrawerActive);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'stickers_event.dart';
part 'stickers_state.dart';

class StickersBloc extends Bloc<StickersEvent, StickersState> {
  StickersBloc() : super(const StickersState());

  @override
  Stream<StickersState> mapEventToState(StickersEvent event) async* {
    if (event is StickersModeToggled) {
      yield _mapStickersModeToggledToState(state);
    } else if (event is StickerSelected) {
      yield _mapStickerSelectedToState(event, state);
    } else if (event is StickersCleared) {
      yield _mapStickersClearedToState(state);
    }
  }

  StickersState _mapStickersModeToggledToState(StickersState state) {
    return state.copyWith(
      mode:
          state.mode.isNotActive ? StickersMode.active : StickersMode.inactive,
    );
  }

  StickersState _mapStickerSelectedToState(
    StickerSelected event,
    StickersState state,
  ) {
    return state.copyWith(
      stickers: List.of(state.stickers)..add(event.sticker),
    );
  }

  StickersState _mapStickersClearedToState(StickersState state) {
    return state.copyWith(stickers: []);
  }
}

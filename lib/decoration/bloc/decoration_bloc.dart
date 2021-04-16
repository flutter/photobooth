import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'decoration_event.dart';
part 'decoration_state.dart';

class DecorationBloc extends Bloc<DecorationEvent, DecorationState> {
  DecorationBloc() : super(const DecorationState());

  @override
  Stream<DecorationState> mapEventToState(DecorationEvent event) async* {
    if (event is DecorationModeToggled) {
      yield _mapDecorationModeToggledToState(state);
    } else if (event is DecorationStickerSelected) {
      yield _mapStickerSelectedToState(event, state);
    } else if (event is StickersCleared) {
      yield _mapStickersClearedToState(state);
    }
  }

  DecorationState _mapDecorationModeToggledToState(DecorationState state) {
    return state.copyWith(
      mode: state.mode.isNotActive
          ? DecorationMode.active
          : DecorationMode.inactive,
    );
  }

  DecorationState _mapStickerSelectedToState(
    DecorationStickerSelected event,
    DecorationState state,
  ) {
    return state.copyWith(
      stickers: List.of(state.stickers)..add(event.sticker),
    );
  }

  DecorationState _mapStickersClearedToState(
    DecorationState state,
  ) {
    return state.copyWith(
      stickers: [],
    );
  }
}

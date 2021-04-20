import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'photobooth_event.dart';
part 'photobooth_state.dart';

class PhotoboothBloc extends Bloc<PhotoboothEvent, PhotoboothState> {
  PhotoboothBloc() : super(const PhotoboothState());

  @override
  Stream<PhotoboothState> mapEventToState(PhotoboothEvent event) async* {
    if (event is PhotoboothAndroidToggled) {
      yield state.copyWith(
        android: state.android.copyWith(isSelected: !state.android.isSelected),
      );
    } else if (event is PhotoboothDashToggled) {
      yield state.copyWith(
        dash: state.dash.copyWith(isSelected: !state.dash.isSelected),
      );
    } else if (event is PhotoboothSparkyToggled) {
      yield state.copyWith(
        sparky: state.sparky.copyWith(isSelected: !state.sparky.isSelected),
      );
    } else if (event is PhotoboothAndroidUpdated) {
      yield state.copyWith(
        android: state.android.copyWith(
          position: CharacterAssetPosition(
            dx: event.update.position.dx,
            dy: event.update.position.dy,
          ),
          size: CharacterAssetSize(
            width: event.update.size.width,
            height: event.update.size.height,
          ),
        ),
        constraints: event.update.constraints,
      );
    } else if (event is PhotoboothDashUpdated) {
      yield state.copyWith(
        dash: state.dash.copyWith(
          position: CharacterAssetPosition(
            dx: event.update.position.dx,
            dy: event.update.position.dy,
          ),
          size: CharacterAssetSize(
            width: event.update.size.width,
            height: event.update.size.height,
          ),
        ),
        constraints: event.update.constraints,
      );
    } else if (event is PhotoboothSparkyUpdated) {
      yield state.copyWith(
        sparky: state.sparky.copyWith(
          position: CharacterAssetPosition(
            dx: event.update.position.dx,
            dy: event.update.position.dy,
          ),
          size: CharacterAssetSize(
            width: event.update.size.width,
            height: event.update.size.height,
          ),
        ),
        constraints: event.update.constraints,
      );
    } else if (event is PhotoboothCharactersCleared) {
      yield const PhotoboothState();
    }
  }
}

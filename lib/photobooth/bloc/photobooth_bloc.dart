import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'photobooth_event.dart';
part 'photobooth_state.dart';

class PhotoboothBloc extends Bloc<PhotoboothEvent, PhotoboothState> {
  PhotoboothBloc() : super(const PhotoboothState());

  @override
  Stream<PhotoboothState> mapEventToState(PhotoboothEvent event) async* {
    if (event is PhotoCaptured) {
      yield state.copyWith(image: event.image);
    } else if (event is PhotoCharacterToggled) {
      yield _mapCharacterToggledToState(event, state);
    } else if (event is PhotoCharacterDragged) {
      yield _mapCharacterDraggedToState(event, state);
    } else if (event is PhotoStickerTapped) {
      yield _mapStickerTappedToState(event, state);
    } else if (event is PhotoStickerDragged) {
      yield _mapStickerDraggedToState(event, state);
    } else if (event is PhotoClearStickersTapped) {
      yield state.copyWith(stickers: const <PhotoAsset>[]);
    } else if (event is PhotoClearAllTapped) {
      yield state.copyWith(
        characters: const <PhotoAsset>[],
        stickers: const <PhotoAsset>[],
      );
    }
  }

  PhotoboothState _mapCharacterToggledToState(
    PhotoCharacterToggled event,
    PhotoboothState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((c) => c.asset.name == asset.name);
    final characterExists = index != -1;

    if (characterExists) {
      characters.removeAt(index);
    } else {
      characters.add(PhotoAsset(id: characters.length, asset: asset));
    }

    return state.copyWith(characters: characters);
  }

  PhotoboothState _mapCharacterDraggedToState(
    PhotoCharacterDragged event,
    PhotoboothState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters)
        .replaceWhere(
          (c) => c.id == asset.id,
          (c) => c.copyWith(
            position: PhotoAssetPosition(
              dx: event.update.position.dx,
              dy: event.update.position.dy,
            ),
            size: PhotoAssetSize(
              width: event.update.size.width,
              height: event.update.size.height,
            ),
            constraint: PhotoConstraint(
              width: event.update.constraints.width,
              height: event.update.constraints.height,
            ),
          ),
        )
        .toList();
    return state.copyWith(characters: characters);
  }

  PhotoboothState _mapStickerTappedToState(
    PhotoStickerTapped event,
    PhotoboothState state,
  ) {
    final asset = event.sticker;
    return state.copyWith(
      stickers: List.of(state.stickers)
        ..add(PhotoAsset(id: state.stickers.length, asset: asset)),
    );
  }

  PhotoboothState _mapStickerDraggedToState(
    PhotoStickerDragged event,
    PhotoboothState state,
  ) {
    final asset = event.sticker;
    final stickers = List.of(state.stickers)
        .replaceWhere(
          (c) => c.id == asset.id,
          (c) => c.copyWith(
            position: PhotoAssetPosition(
              dx: event.update.position.dx,
              dy: event.update.position.dy,
            ),
            size: PhotoAssetSize(
              width: event.update.size.width,
              height: event.update.size.height,
            ),
            constraint: PhotoConstraint(
              width: event.update.constraints.width,
              height: event.update.constraints.height,
            ),
          ),
        )
        .toList();
    return state.copyWith(stickers: stickers);
  }
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> replaceWhere(
      bool Function(T element) predicate, T Function(T value) replace) {
    return map(
      (element) => predicate(element) ? replace(element) : element,
    );
  }
}

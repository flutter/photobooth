import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'photo_event.dart';
part 'photo_state.dart';

const _defaultCharacterScale = 0.5;
const _defaultStickerScale = 0.5;

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(const PhotoState());

  @override
  Stream<PhotoState> mapEventToState(PhotoEvent event) async* {
    if (event is PhotoCaptured) {
      yield state.copyWith(image: event.image);
    } else if (event is PhotoConstraintsChanged) {
      yield state.copyWith(
        constraint: PhotoConstraint(width: event.width, height: event.height),
      );
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

  PhotoState _mapCharacterToggledToState(
    PhotoCharacterToggled event,
    PhotoState state,
  ) {
    final asset = event.character.toAsset();
    final characters = List.of(state.characters);
    final index = characters.indexWhere((c) => c.asset.name == asset.name);
    final characterExists = index != -1;

    if (characterExists) {
      characters.removeAt(index);
    } else {
      characters.add(
        PhotoAsset(
          asset: asset,
          position: PhotoAssetPosition(
            dx: state.constraint.width / 2 - (asset.image.width / 2),
            dy: state.constraint.height / 2 - (asset.image.height / 2),
          ),
          size: PhotoAssetSize(
            width: asset.image.width * _defaultCharacterScale,
            height: asset.image.height * _defaultCharacterScale,
          ),
          constraint: state.constraint,
        ),
      );
    }

    return state.copyWith(characters: characters);
  }

  PhotoState _mapCharacterDraggedToState(
    PhotoCharacterDragged event,
    PhotoState state,
  ) {
    final asset = event.character.asset;
    final characters = List.of(state.characters)
        .replaceWhere(
          (c) => c.asset.name == asset.name,
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

  PhotoState _mapStickerTappedToState(
    PhotoStickerTapped event,
    PhotoState state,
  ) {
    final asset = event.sticker;
    return state.copyWith(
      stickers: List.of(state.stickers)
        ..add(
          PhotoAsset(
            asset: asset,
            position: PhotoAssetPosition(
              dx: state.constraint.width / 2 - (asset.image.width / 2),
              dy: state.constraint.height / 2 - (asset.image.height / 2),
            ),
            size: PhotoAssetSize(
              width: asset.image.width * _defaultStickerScale,
              height: asset.image.height * _defaultStickerScale,
            ),
            constraint: state.constraint,
          ),
        ),
    );
  }

  PhotoState _mapStickerDraggedToState(
    PhotoStickerDragged event,
    PhotoState state,
  ) {
    final asset = event.sticker;
    final stickers = List.of(state.stickers)
        .replaceWhere(
          (c) => c.asset.name == asset.name,
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

extension on Character {
  Asset toAsset() {
    switch (this) {
      case Character.android:
        return Assets.android;
      case Character.dash:
        return Assets.dash;
      case Character.sparky:
        return Assets.sparky;
    }
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

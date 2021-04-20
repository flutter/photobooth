// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockAsset extends Mock implements Asset {}

void main() {
  group('StickersBloc', () {
    test('initial state is StickersState()', () {
      expect(StickersBloc().state, equals(StickersState()));
    });

    group('StickersModeToggled', () {
      blocTest<StickersBloc, StickersState>(
        'emits mode: active when inactive',
        build: () => StickersBloc(),
        seed: () => StickersState(mode: StickersMode.inactive),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(mode: StickersMode.active),
        ],
      );

      blocTest<StickersBloc, StickersState>(
        'emits mode: inactive when active',
        build: () => StickersBloc(),
        seed: () => StickersState(mode: StickersMode.active),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(mode: StickersMode.inactive),
        ],
      );
    });

    group('StickerSelected', () {
      final sticker = MockAsset();
      blocTest<StickersBloc, StickersState>(
        'emits state with appended sticker',
        build: () => StickersBloc(),
        act: (bloc) => bloc.add(StickerSelected(sticker: sticker)),
        expect: () => [
          StickersState(stickers: [sticker]),
        ],
      );
    });

    group('StickersCleared', () {
      blocTest<StickersBloc, StickersState>(
        'emits state with empty stickers',
        build: () => StickersBloc(),
        act: (bloc) => bloc.add(StickersCleared()),
        expect: () => [
          StickersState(stickers: []),
        ],
      );
    });
  });
}

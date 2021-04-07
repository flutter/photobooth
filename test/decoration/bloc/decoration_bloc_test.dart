// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockAsset extends Mock implements Asset {}

void main() {
  group('DecorationBloc', () {
    test('initial state is DecorationState()', () {
      expect(DecorationBloc().state, equals(DecorationState()));
    });

    group('DecorationModeToggled', () {
      blocTest<DecorationBloc, DecorationState>(
        'emits mode: active when inactive',
        build: () => DecorationBloc(),
        seed: () => DecorationState(mode: DecorationMode.inactive),
        act: (bloc) => bloc.add(DecorationModeToggled()),
        expect: () => [
          DecorationState(mode: DecorationMode.active),
        ],
      );

      blocTest<DecorationBloc, DecorationState>(
        'emits mode: inactive when active',
        build: () => DecorationBloc(),
        seed: () => DecorationState(mode: DecorationMode.active),
        act: (bloc) => bloc.add(DecorationModeToggled()),
        expect: () => [
          DecorationState(mode: DecorationMode.inactive),
        ],
      );
    });

    group('DecorationStickerSelected', () {
      final sticker = MockAsset();
      blocTest<DecorationBloc, DecorationState>(
        'emits state with appended sticker',
        build: () => DecorationBloc(),
        act: (bloc) => bloc.add(DecorationStickerSelected(sticker: sticker)),
        expect: () => [
          DecorationState(stickers: [sticker]),
        ],
      );
    });
  });
}

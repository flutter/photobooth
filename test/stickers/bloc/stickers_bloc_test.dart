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

    group('StickersDrawerToggled', () {
      blocTest<StickersBloc, StickersState>(
        'emits isDrawerActive: true when isDrawerActive: false',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: false,
          displayOpenStickersTooltip: true,
        ),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(
            isDrawerActive: true,
            displayOpenStickersTooltip: false,
          ),
        ],
      );

      blocTest<StickersBloc, StickersState>(
        'emits isDrawerActive: false when isDrawerActive: true',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: true,
          displayOpenStickersTooltip: false,
        ),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(
            isDrawerActive: false,
            displayOpenStickersTooltip: false,
          ),
        ],
      );
    });

    group('StickersClearTooltipShowed', () {
      blocTest<StickersBloc, StickersState>(
        'emits state with displayClearStickersTooltip:false',
        build: () => StickersBloc(),
        seed: () => StickersState(
          displayClearStickersTooltip: true,
        ),
        act: (bloc) => bloc.add(StickersClearTooltipShowed()),
        expect: () => [
          StickersState(
            displayClearStickersTooltip: false,
          ),
        ],
      );
    });
  });
}

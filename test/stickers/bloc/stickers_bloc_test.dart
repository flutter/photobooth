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

    group('StickersDrawerTabSelected', () {
      blocTest<StickersBloc, StickersState>(
        'emits state with updated tab selected',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: true,
          shouldDisplayPropsReminder: false,
        ),
        act: (bloc) => bloc.add(StickersDrawerTabSelected(tabSelected: 1)),
        expect: () => [
          StickersState(
            isDrawerActive: true,
            shouldDisplayPropsReminder: false,
            tabSelected: 1,
          ),
        ],
      );
    });

    group('StickersDrawerToggled', () {
      blocTest<StickersBloc, StickersState>(
        'emits isDrawerActive: true when isDrawerActive: false',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: false,
          shouldDisplayPropsReminder: false,
        ),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(
            isDrawerActive: true,
            shouldDisplayPropsReminder: false,
          ),
        ],
      );

      blocTest<StickersBloc, StickersState>(
        'emits isDrawerActive: false when isDrawerActive: true',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: true,
          shouldDisplayPropsReminder: false,
        ),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(
            isDrawerActive: false,
            shouldDisplayPropsReminder: false,
          ),
        ],
      );

      blocTest<StickersBloc, StickersState>(
        'emits shouldDisplayPropsReminder:false when StickersDrawerToggled',
        build: () => StickersBloc(),
        seed: () => StickersState(
          isDrawerActive: false,
          shouldDisplayPropsReminder: true,
        ),
        act: (bloc) => bloc.add(StickersDrawerToggled()),
        expect: () => [
          StickersState(
            isDrawerActive: true,
            shouldDisplayPropsReminder: false,
          ),
        ],
      );
    });
  });
}

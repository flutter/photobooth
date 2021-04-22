// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }
}

void main() {
  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState.initial());
  });

  group('ShareProgressOverlay', () {
    testWidgets(
        'displays loading overlay '
        'when ShareBloc state is loading', (tester) async {
      tester.setDisplaySize(const Size(1920, 1080));
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.loading()]),
        initialState: ShareState.loading(),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);

      expect(find.byKey(Key('shareProgressOverlay_loading')), findsOneWidget);
    });

    testWidgets(
        'displays mobile loading overlay '
        'when ShareBloc state is loading '
        'and resolution is mobile', (tester) async {
      tester.setDisplaySize(const Size(320, 800));
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.loading()]),
        initialState: ShareState.loading(),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);

      expect(find.byKey(Key('shareProgressOverlay_mobile')), findsOneWidget);
    });

    testWidgets(
        'displays desktop loading overlay '
        'when ShareBloc state is loading '
        'and resolution is desktop', (tester) async {
      tester.setDisplaySize(const Size(1920, 1080));
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.loading()]),
        initialState: ShareState.loading(),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);

      expect(find.byKey(Key('shareProgressOverlay_desktop')), findsOneWidget);
    });

    testWidgets(
        'displays nothing '
        'when ShareBloc state is not loading', (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.initial()]),
        initialState: ShareState.initial(),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);

      expect(find.byKey(Key('shareProgressOverlay_nothing')), findsOneWidget);
    });
  });
}

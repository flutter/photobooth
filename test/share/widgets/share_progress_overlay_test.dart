// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockXFile extends Mock implements XFile {}

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
  final bytes = Uint8List.fromList([]);
  late ShareBloc shareBloc;
  late XFile file;

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    file = MockXFile();
    when(() => shareBloc.state).thenReturn(ShareState());
  });

  group('ShareProgressOverlay', () {
    testWidgets(
        'displays loading overlay '
        'when ShareBloc upload status is loading', (tester) async {
      tester.setDisplaySize(const Size(1920, 1080));
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.loading,
          file: file,
          bytes: bytes,
        ),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);
      expect(find.byKey(Key('shareProgressOverlay_loading')), findsOneWidget);
    });

    testWidgets(
        'displays mobile loading overlay '
        'when ShareBloc upload status is loading '
        'and resolution is mobile', (tester) async {
      tester.setDisplaySize(const Size(320, 800));
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.loading,
          file: file,
          bytes: bytes,
        ),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);
      expect(find.byKey(Key('shareProgressOverlay_mobile')), findsOneWidget);
    });

    testWidgets(
        'displays desktop loading overlay '
        'when ShareBloc upload status is loading '
        'and resolution is desktop', (tester) async {
      tester.setDisplaySize(const Size(1920, 1080));
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.loading,
          file: file,
          bytes: bytes,
        ),
      );
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);
      expect(find.byKey(Key('shareProgressOverlay_desktop')), findsOneWidget);
    });

    testWidgets(
        'displays nothing '
        'when ShareBloc state is not loading', (tester) async {
      await tester.pumpApp(ShareProgressOverlay(), shareBloc: shareBloc);
      expect(find.byKey(Key('shareProgressOverlay_nothing')), findsOneWidget);
    });
  });
}

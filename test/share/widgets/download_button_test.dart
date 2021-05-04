import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockXFile extends Mock implements XFile {}

void main() {
  final bytes = Uint8List.fromList([]);
  group('DownloadButton', () {
    late ShareBloc shareBloc;

    setUpAll(() {
      registerFallbackValue<ShareEvent>(FakeShareEvent());
      registerFallbackValue<ShareState>(FakeShareState());
    });

    setUp(() {
      shareBloc = MockShareBloc();

      when(() => shareBloc.state).thenReturn(const ShareState());
    });

    testWidgets('renders OutlinedButton', (tester) async {
      await tester.pumpApp(const DownloadButton(), shareBloc: shareBloc);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets(
        'does not render loading indicator when compositing but not tapped',
        (tester) async {
      when(() => shareBloc.state).thenReturn(
        const ShareState(compositeStatus: ShareStatus.loading),
      );

      await tester.pumpApp(const DownloadButton(), shareBloc: shareBloc);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders loading indicator when compositing and tapped',
        (tester) async {
      when(() => shareBloc.state).thenReturn(
        const ShareState(
          compositeStatus: ShareStatus.loading,
          isDownloadRequested: true,
        ),
      );

      await tester.pumpApp(const DownloadButton(), shareBloc: shareBloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('downloads file on success', (tester) async {
      final file = MockXFile();
      when(() => file.saveTo(any())).thenAnswer((_) async => null);
      whenListen(
        shareBloc,
        Stream.fromIterable([
          const ShareState(compositeStatus: ShareStatus.loading),
          ShareState(
            compositeStatus: ShareStatus.success,
            file: file,
            bytes: bytes,
          ),
        ]),
      );

      await tester.pumpApp(const DownloadButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(OutlinedButton));

      verify(() => file.saveTo('')).called(1);
    });
  });
}

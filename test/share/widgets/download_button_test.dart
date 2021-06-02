import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockXFile extends Mock implements XFile {}

void main() {
  group('DownloadButton', () {
    late XFile file;

    setUp(() {
      file = MockXFile();
    });

    testWidgets('renders OutlinedButton', (tester) async {
      await tester.pumpApp(DownloadButton(file: file));
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('downloads file on tap', (tester) async {
      when(() => file.saveTo(any())).thenAnswer((_) async {});

      await tester.pumpApp(DownloadButton(file: file));
      await tester.tap(find.byType(OutlinedButton));

      verify(() => file.saveTo('')).called(1);
    });
  });
}

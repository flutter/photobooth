// ignore_for_file: prefer_const_constructors
import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/helpers.dart';

class MockXFile extends Mock implements XFile {}

void main() {
  group('DownloadButton', () {
    late XFile file;

    setUp(() {
      file = MockXFile();
      when(() => file.saveTo(any())).thenAnswer((_) async {});
    });

    testWidgets('tapping on download photo button triggers a save',
        (tester) async {
      await tester.pumpApp(DownloadButton(file: file));
      await tester.tap(find.byType(DownloadButton));
      expect(find.byType(DownloadButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      verify(() => file.saveTo('')).called(1);
    });
  });
}

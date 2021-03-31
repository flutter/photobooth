// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('DownloadButton', () {
    testWidgets('tapping on download photo button does nothing',
        (tester) async {
      await tester.pumpApp(DownloadButton());
      await tester.tap(find.byType(DownloadButton));
      expect(find.byType(DownloadButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

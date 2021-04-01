// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('RetakeButton', () {
    testWidgets('tapping on RetakeButton does nothing', (tester) async {
      await tester.pumpApp(RetakeButton());
      await tester.tap(find.byType(RetakeButton));
      expect(find.byType(RetakeButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

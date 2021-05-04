// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareTryAgainButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(ShareTryAgainButton());
      expect(find.byType(ShareTryAgainButton), findsOneWidget);
    });

    testWidgets('pops when tapped', (tester) async {
      await tester.pumpApp(ShareTryAgainButton());
      await tester.tap(find.byType(ShareTryAgainButton));
      await tester.pumpAndSettle();
      expect(find.byType(ShareTryAgainButton), findsNothing);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('PlatformBuilder', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          mobile: Container(),
          desktop: Container(),
        ),
      );
      expect(find.byType(PlatformBuilder), findsOneWidget);
    });
  });
}

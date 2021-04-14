import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

void main() {
  group('PlatformBuilder', () {
    testWidgets('renders without platform helper parameter', (tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          mobile: Container(),
          desktop: Container(),
        ),
      );
      expect(find.byType(PlatformBuilder), findsOneWidget);
    });

    testWidgets('renders with platform helper parameter', (tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          mobile: Container(),
          desktop: Container(),
          platformHelper: PlatformHelper(),
        ),
      );
      expect(find.byType(PlatformBuilder), findsOneWidget);
    });
  });
}

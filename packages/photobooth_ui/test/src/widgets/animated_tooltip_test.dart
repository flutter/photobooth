import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AnimatedTooltip', () {
    testWidgets('renders AppTooltip', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedTooltip(
            text: 'Test',
          ),
        ),
      );

      expect(find.byType(AppTooltip), findsOneWidget);
    });

    testWidgets('tooltip will dissappears after certain duration',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedTooltip(
            text: 'Test',
          ),
        ),
      );

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1.0);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.0);
    });
  });
}

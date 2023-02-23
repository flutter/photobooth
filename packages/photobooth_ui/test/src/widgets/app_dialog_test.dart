import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('showAppDialog', () {
    testWidgets('should show dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppDialog<void>(
                context: context,
                child: const Text('dialog'),
              ),
              child: const Text('open dialog'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}

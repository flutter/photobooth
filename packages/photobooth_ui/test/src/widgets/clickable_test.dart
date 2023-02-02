import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('Clickable', () {
    testWidgets('makes the given child tappable/clickable', (tester) async {
      var wasClicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Clickable(
            onPressed: () {
              wasClicked = true;
            },
            child: const Text('Click me'),
          ),
        ),
      );
      expect(find.text('Click me'), findsOneWidget);
      expect(wasClicked, isFalse);
      await tester.tap(find.text('Click me'));
      await tester.pumpAndSettle();
      expect(wasClicked, isTrue);
    });
  });
}

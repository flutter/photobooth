// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AppTooltip', () {
    testWidgets('renders Tooltip by default', (tester) async {
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltip(
              message: 'message',
              child: SizedBox(key: target),
            ),
          ),
        ),
      );
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.byKey(target), findsOneWidget);
      expect(find.text('message'), findsNothing);
    });

    testWidgets('renders tooltip message when visible is true', (tester) async {
      const target = Key('__key__');
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: AppTooltip.custom(
              visible: true,
              message: 'message',
              child: SizedBox(key: target),
            ),
          ),
        ),
      );
      expect(find.byType(Tooltip), findsNothing);
      expect(find.byKey(target), findsOneWidget);
      expect(find.text('message'), findsOneWidget);
    });

    testWidgets('does not render tooltip message when visible is false',
        (tester) async {
      const target = Key('__key__');
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: AppTooltip.custom(
              visible: false,
              message: 'message',
              child: SizedBox(key: target),
            ),
          ),
        ),
      );
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.byKey(target), findsOneWidget);
      expect(find.text('message'), findsNothing);
    });
  });
}

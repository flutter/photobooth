// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AnimatedTooltip', () {
    testWidgets('renders tooltip after 500ms', (tester) async {
      final textTooltip = 'Test tooltip';
      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedTooltip(
            globalKey: GlobalKey(),
            message: textTooltip,
            child: Text('test'),
          ),
        ),
      );
      expect(find.text(textTooltip), findsNothing);

      await tester.pump(Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text(textTooltip), findsOneWidget);
    });

    testWidgets('tooltip will dissappear after 3s', (tester) async {
      final textTooltip = 'Test tooltip';
      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedTooltip(
            globalKey: GlobalKey(),
            message: textTooltip,
            child: Text('test'),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.pump(Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text(textTooltip), findsNothing);
    });

    testWidgets('tooltip will not dissappear if it is persistent',
        (tester) async {
      final textTooltip = 'Test tooltip';
      await tester.pumpWidget(
        MaterialApp(
          home: AnimatedTooltip(
            globalKey: GlobalKey(),
            isPersistent: true,
            message: textTooltip,
            child: Text('test'),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.pump(Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text(textTooltip), findsOneWidget);
    });
  });
}

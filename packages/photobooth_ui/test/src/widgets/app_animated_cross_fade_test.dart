// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AppAnimatedCrossFade', () {
    testWidgets('renders both children', (tester) async {
      await tester.pumpWidget(
        AppAnimatedCrossFade(
          firstChild: SizedBox(key: Key('first')),
          secondChild: SizedBox(key: Key('second')),
          crossFadeState: CrossFadeState.showFirst,
        ),
      );
      expect(find.byKey(Key('first')), findsOneWidget);
      expect(find.byKey(Key('second')), findsOneWidget);
    });
  });
}

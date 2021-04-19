import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/helpers.dart';

void main() {
  group('AdaptiveBuilder', () {
    testWidgets('notifies small windows', (tester) async {
      late WindowBreakpoint result;
      tester.setDisplaySize(10);
      await tester.pumpWidget(MaterialApp(
        home: AdaptiveBuilder(builder: (context, breakpoint) {
          result = breakpoint;
          return Container();
        }),
      ));
      expect(result, WindowBreakpoint.small);
    });

    testWidgets('notifies large windows', (tester) async {
      late WindowBreakpoint result;
      tester.setDisplaySize(2000);
      await tester.pumpWidget(MaterialApp(
        home: AdaptiveBuilder(builder: (context, breakpoint) {
          result = breakpoint;
          return Container();
        }),
      ));
      expect(result, WindowBreakpoint.large);
    });
  });
}

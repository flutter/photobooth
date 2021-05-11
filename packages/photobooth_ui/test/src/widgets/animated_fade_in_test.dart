import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AnimatedFadeIn', () {
    testWidgets('fades in child', (tester) async {
      final key = UniqueKey();
      final child = SizedBox(key: key);
      await tester.pumpWidget(AnimatedFadeIn(child: child));

      var animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, equals(0.0));

      await tester.pumpAndSettle();

      animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, equals(1.0));
      expect(find.byKey(key), findsOneWidget);
    });
  });
}

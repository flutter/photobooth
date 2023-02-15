@TestOn('chrome')
library;

import 'dart:js';

import 'package:analytics/src/analytics_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockJsObject extends Mock implements JsObject {}

void main() {
  group('trackEvent', () {
    late JsObject context;

    setUp(() {
      context = MockJsObject();
      testContext = context;
    });

    test('calls ga on window with correct args', () {
      const category = 'category';
      const action = 'action';
      const label = 'label';
      expect(
        () => trackEvent(
          category: category,
          action: action,
          label: label,
        ),
        returnsNormally,
      );
      verify(
        () => context.callMethod(
          'ga',
          <dynamic>['send', 'event', category, action, label],
        ),
      ).called(1);
    });
  });
}

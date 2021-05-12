import 'dart:js';

import 'package:flutter/foundation.dart';

/// Exposed [JsObject] for testing purposes.
@visibleForTesting
JsObject? testContext;

/// Method which tracks an event for the provided
/// [category], [action], and [label].
void trackEvent({
  required String category,
  required String action,
  required String label,
}) {
  try {
    (testContext ?? context).callMethod(
      'ga',
      <dynamic>['send', 'event', category, action, label],
    );
  } catch (_) {}
}

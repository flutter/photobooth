import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// Web Implementation of [PlatformHelper]
class PlatformHelper {
  /// Window can be overridden for testing purposes only.
  @visibleForTesting
  html.Window? window;

  html.Window get _window => window ?? html.window;

  /// Returns whether the current platform is running on a mobile device.
  bool get isMobile {
    final userAgent = _window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('android') ||
        userAgent.contains('ipad')) return true;
    return false;
  }
}

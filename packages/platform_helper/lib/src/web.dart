import 'dart:html' as html;

import 'package:flutter/foundation.dart';

class PlatformHelper {
  PlatformHelper();

  @visibleForTesting
  html.Window? window;

  html.Window get _window => window ?? html.window;

  bool get isMobile {
    final userAgent = _window.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('android') ||
        userAgent.contains('ipad')) return true;
    return false;
  }
}

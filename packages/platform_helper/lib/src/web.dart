import 'dart:html' as html;

class PlatformHelper {
  PlatformHelper();
  html.Window? localWindow;

  bool get isMobile {
    localWindow ??= html.window;
    final userAgent = localWindow!.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('android') ||
        userAgent.contains('ipad')) return true;
    return false;
  }
}

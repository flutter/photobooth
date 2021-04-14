import 'dart:html' as html;

class PlatformHelper {
  PlatformHelper();
  html.Window? localWindow;

  void setWindow(html.Window window) {
    localWindow = window;
  }

  bool get isMobile {
    if (localWindow == null) {
      setWindow(html.window);
    }
    final userAgent = localWindow!.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('android') ||
        userAgent.contains('ipad')) return true;
    return false;
  }
}

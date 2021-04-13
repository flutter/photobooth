import 'dart:html';

/// Helper for web
class WebHelper {
  /// Return true if the current device is iPhone, Android, or iPad
  bool isMobile() {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    // smartphone
    if (userAgent.contains('iphone') ||
        userAgent.contains('android') ||
        userAgent.contains('ipad')) return true;
    return false;
  }
}

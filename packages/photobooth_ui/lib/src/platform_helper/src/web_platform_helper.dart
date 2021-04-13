import 'dart:html';

/// Returns true if it is a mobile device. Web implementation
bool get isMobileImpl {
  final userAgent = window.navigator.userAgent.toString().toLowerCase();
  if (userAgent.contains('iphone') ||
      userAgent.contains('android') ||
      userAgent.contains('ipad')) return true;
  return false;
}

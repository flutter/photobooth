// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Removes the handed-coded piece of HTML used as the app loading
/// indicator/splash screen.
void removeLoadingIndicator() {
  html.document.querySelector('#loading-indicator')?.remove();
}

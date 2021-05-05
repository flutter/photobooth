import 'dart:html' as html;

/// Removes the handed-coded piece of HTML used as the app loading
/// indicator/splash screen.
void removeLoadingIndicator() {
  html.document.querySelector('#loading-indicator')?.remove();
}

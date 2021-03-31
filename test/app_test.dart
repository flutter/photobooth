import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/landing/landing.dart';

void main() {
  group('App', () {
    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}

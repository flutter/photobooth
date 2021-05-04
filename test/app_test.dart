import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

void main() {
  group('App', () {
    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(App(
        authenticationRepository: MockAuthenticationRepository(),
        photosRepository: MockPhotosRepository(),
      ));
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}

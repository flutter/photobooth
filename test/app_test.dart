import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:share_photo_repository/share_photo_repository.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockSharePhotoRepository extends Mock implements SharePhotoRepository {}

void main() {
  group('App', () {
    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(App(
        photosRepository: MockPhotosRepository(),
        sharePhotoRepository: MockSharePhotoRepository(),
      ));
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

import 'helpers/helpers.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

void main() {
  group('App', () {
    testWidgets('uses default theme on large devices', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
      await tester.pumpWidget(
        App(
          authenticationRepository: MockAuthenticationRepository(),
          photosRepository: MockPhotosRepository(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.displayLarge!.fontSize,
        equals(PhotoboothTheme.standard.textTheme.displayLarge!.fontSize),
      );
    });

    testWidgets('uses small theme on small devices', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 500));
      await tester.pumpWidget(
        App(
          authenticationRepository: MockAuthenticationRepository(),
          photosRepository: MockPhotosRepository(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.displayLarge!.fontSize,
        equals(PhotoboothTheme.small.textTheme.displayLarge!.fontSize),
      );
    });

    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: MockAuthenticationRepository(),
          photosRepository: MockPhotosRepository(),
        ),
      );
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}

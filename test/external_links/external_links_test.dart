import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  group('External links', () {
    group('launchGoogleIOLink', () {
      test('launches correct link', () async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              any(),
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);

        await launchGoogleIOLink();

        verify(() => mock.launch(
              googleIOExternalLink,
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).called(1);
      });
    });

    group('launchFlutterDevLink', () {
      test('launches correct link', () async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              any(),
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);

        await launchFlutterDevLink();

        verify(() => mock.launch(
              flutterDevExternalLink,
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).called(1);
      });
    });

    group('launchFirebaseLink', () {
      test('launches correct link', () async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              any(),
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);

        await launchFirebaseLink();

        verify(() => mock.launch(
              firebaseExternalLink,
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).called(1);
      });
    });

    group('launchPhotoboothEmail', () {
      test('launches correct link', () async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              any(),
              useSafariVC: false,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);

        await launchPhotoboothEmail();

        verify(() => mock.launch(
              photoboothEmail,
              useSafariVC: false,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).called(1);
      });
    });

    group('launchOpenSourceLink', () {
      test('launches correct link', () async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              any(),
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);

        await launchOpenSourceLink();

        verify(() => mock.launch(
              openSourceLink,
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).called(1);
      });
    });
  });
}

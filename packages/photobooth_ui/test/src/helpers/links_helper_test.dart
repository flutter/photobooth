import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late UrlLauncherPlatform mock;

  setUp(() {
    mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;
  });

  group('openLink', () {
    test('launches the link', () async {
      when(() => mock.canLaunch('url')).thenAnswer((_) async => true);
      when(() => mock.launch(
            'url',
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).thenAnswer((_) async => true);
      await openLink('url');
      verify(() => mock.launch(
            'url',
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).called(1);
    });

    test('executes the onError callback when it cannot launch', () async {
      var wasCalled = false;
      when(() => mock.canLaunch('url')).thenAnswer((_) async => false);
      when(() => mock.launch(
            'url',
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).thenAnswer((_) async => true);
      await openLink('url', onError: () {
        wasCalled = true;
      });
      await expectLater(wasCalled, isTrue);
    });
  });
}

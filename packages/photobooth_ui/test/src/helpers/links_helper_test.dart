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
  late UrlLauncherPlatform original;

  setUpAll(() {
    registerFallbackValue(const LaunchOptions());
  });

  setUp(() {
    original = UrlLauncherPlatform.instance;
    mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = original;
  });

  group('openLink', () {
    test('launches the link', () async {
      when(() => mock.canLaunch('url')).thenAnswer((_) async => true);
      when(() => mock.launchUrl('url', any())).thenAnswer((_) async => true);
      await openLink('url');
      verify(() => mock.launchUrl('url', any())).called(1);
    });

    test('executes the onError callback when it cannot launch', () async {
      var wasCalled = false;
      when(() => mock.canLaunch('url')).thenAnswer((_) async => false);
      when(() => mock.launchUrl('url', any())).thenAnswer((_) async => true);
      await openLink(
        'url',
        onError: () {
          wasCalled = true;
        },
      );
      await expectLater(wasCalled, isTrue);
    });
  });
}

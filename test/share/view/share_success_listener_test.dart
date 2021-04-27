// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late ShareBloc shareBloc;

  const shareUrl = 'share-url';

  setUp(() {});

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState.initial());
  });

  group('ShareSuccessListener', () {
    testWidgets(
        'opens share link '
        'when ShareBloc emits success', (tester) async {
      final mock = MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mock.launch(
            shareUrl,
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).thenAnswer((_) async => true);

      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.success(shareUrl: shareUrl)]),
      );
      await tester.pumpApp(
        ShareSuccessListener(
          child: SizedBox(),
        ),
        shareBloc: shareBloc,
      );
      await tester.pumpAndSettle();

      verify(() => mock.launch(
            shareUrl,
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).called(1);
    });
  });
}

// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class MockXFile extends Mock implements XFile {}

void main() {
  const shareUrl = 'http://share-url.com';
  final bytes = Uint8List.fromList([]);

  late ShareBloc shareBloc;
  late PlatformHelper platformHelper;
  late XFile file;

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState());

    file = MockXFile();
    platformHelper = MockPlatformHelper();
  });

  group('ShareStateListener', () {
    group('error', () {
      testWidgets(
          'displays ShareErrorBottomSheet '
          'when ShareBloc emits error '
          'and platform is mobile', (tester) async {
        whenListen(
          shareBloc,
          Stream.fromIterable([
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.loading,
              file: file,
              bytes: bytes,
            ),
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.failure,
              file: file,
              bytes: bytes,
            ),
          ]),
        );
        when(() => platformHelper.isMobile).thenReturn(true);
        await tester.pumpApp(
          ShareStateListener(
            platformHelper: platformHelper,
            child: SizedBox(),
          ),
          shareBloc: shareBloc,
        );
        await tester.pumpAndSettle();

        expect(find.byType(ShareErrorBottomSheet), findsOneWidget);
      });

      testWidgets(
          'displays ShareErrorDialog '
          'when ShareBloc emits error '
          'and platform is not mobile and it is landscape', (tester) async {
        whenListen(
          shareBloc,
          Stream.fromIterable([
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.loading,
              file: file,
              bytes: bytes,
            ),
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.failure,
              file: file,
              bytes: bytes,
            ),
          ]),
        );
        when(() => platformHelper.isMobile).thenReturn(false);
        tester.setLandscapeDisplaySize();
        await tester.pumpApp(
          ShareStateListener(
            platformHelper: platformHelper,
            child: SizedBox(),
          ),
          shareBloc: shareBloc,
        );
        await tester.pumpAndSettle();

        expect(find.byType(ShareErrorDialog), findsOneWidget);
      });

      testWidgets(
          'does not display ShareErrorBottomSheet '
          'when ShareBloc emits state other than error '
          'and platform is mobile', (tester) async {
        whenListen(
          shareBloc,
          Stream.fromIterable([
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.loading,
              file: file,
              bytes: bytes,
            ),
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.success,
              file: file,
              bytes: bytes,
              twitterShareUrl: shareUrl,
              facebookShareUrl: shareUrl,
            ),
          ]),
        );
        when(() => platformHelper.isMobile).thenReturn(true);
        await tester.pumpApp(
          ShareStateListener(
            platformHelper: platformHelper,
            child: SizedBox(),
          ),
          shareBloc: shareBloc,
        );
        await tester.pumpAndSettle();

        expect(find.byType(ShareErrorBottomSheet), findsNothing);
      });

      testWidgets(
          'does not display ShareErrorDialog '
          'when ShareBloc emits state different than error '
          'and platform is desktop', (tester) async {
        whenListen(
          shareBloc,
          Stream.fromIterable([ShareState()]),
        );
        when(() => platformHelper.isMobile).thenReturn(false);
        await tester.pumpApp(
          ShareStateListener(
            platformHelper: platformHelper,
            child: SizedBox(),
          ),
          shareBloc: shareBloc,
        );
        await tester.pumpAndSettle();

        expect(find.byType(ShareErrorDialog), findsNothing);
      });
    });

    group('success', () {
      testWidgets(
          'opens share link '
          'when ShareBloc emits success', (tester) async {
        final mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => mock.launch(
            shareUrl,
            useSafariVC: true,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          ),
        ).thenAnswer((_) async => true);

        whenListen(
          shareBloc,
          Stream.fromIterable([
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.loading,
              file: file,
              bytes: bytes,
            ),
            ShareState(
              compositeStatus: ShareStatus.success,
              uploadStatus: ShareStatus.success,
              shareUrl: ShareUrl.twitter,
              file: file,
              bytes: bytes,
              twitterShareUrl: shareUrl,
              facebookShareUrl: shareUrl,
            ),
          ]),
        );

        await tester.pumpApp(
          ShareStateListener(child: SizedBox()),
          shareBloc: shareBloc,
        );

        await tester.pumpAndSettle();

        verify(
          () => mock.launch(
            shareUrl,
            useSafariVC: true,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          ),
        ).called(1);
      });
    });
  });
}

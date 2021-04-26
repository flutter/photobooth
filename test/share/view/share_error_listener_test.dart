// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  late ShareBloc shareBloc;
  late PlatformHelper platformHelper;

  setUp(() {});

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState.initial());

    platformHelper = MockPlatformHelper();
  });

  group('ShareErrorListener', () {
    testWidgets(
        'displays ShareErrorBottomSheet '
        'when ShareBloc emits error '
        'and platform is mobile', (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.error()]),
      );
      when(() => platformHelper.isMobile).thenReturn(true);
      await tester.pumpApp(
        ShareErrorListener(
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
        'and platform is desktop', (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.error()]),
      );
      when(() => platformHelper.isMobile).thenReturn(false);
      await tester.pumpApp(
        ShareErrorListener(
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
        'when ShareBloc emits state different than error '
        'and platform is mobile', (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([ShareState.success(shareUrl: 'share-url')]),
      );
      when(() => platformHelper.isMobile).thenReturn(true);
      await tester.pumpApp(
        ShareErrorListener(
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
        Stream.fromIterable([ShareState.success(shareUrl: 'share-url')]),
      );
      when(() => platformHelper.isMobile).thenReturn(false);
      await tester.pumpApp(
        ShareErrorListener(
          platformHelper: platformHelper,
          child: SizedBox(),
        ),
        shareBloc: shareBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ShareErrorDialog), findsNothing);
    });
  });
}

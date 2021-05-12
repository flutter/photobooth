// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue<StickersEvent>(FakeStickersEvent());
    registerFallbackValue<StickersState>(FakeStickersState());
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });
  group('StickersDrawerLayer', () {
    late PhotoboothBloc photoboothBloc;
    late StickersBloc stickersBloc;
    late PlatformHelper platformHelper;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      stickersBloc = MockStickersBloc();
      platformHelper = MockPlatformHelper();
    });

    group('DesktopStickersDrawer', () {
      testWidgets(
          'renders DesktopStickersDrawer when '
          'is not mobile, mode is active and orientation is landscape',
          (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: true),
        );
        tester.setLandscapeDisplaySize();
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsOneWidget);
      });

      testWidgets(
          'does not render DesktopStickersDrawer when '
          'is not mobile, and mode is inactive', (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: false),
        );
        tester.setLandscapeDisplaySize();
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsNothing);
      });

      testWidgets(
          'does not render DesktopStickersDrawer when '
          'is not mobile, and orientation is portrait', (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: true),
        );
        tester.setPortraitDisplaySize();
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsNothing);
      });

      testWidgets('adds StickerSelected when StickerChoice tapped',
          (tester) async {
        final sticker = Assets.props.first;
        when(() => platformHelper.isMobile).thenReturn(false);
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: true),
        );
        tester.setLandscapeDisplaySize();
        when(() => photoboothBloc.state).thenReturn(
          PhotoboothState(stickers: [PhotoAsset(id: '0', asset: sticker)]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
          photoboothBloc: photoboothBloc,
        );
        final stickerChoice =
            tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
        stickerChoice.onPressed();
        verify(() => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)))
            .called(1);
      });

      testWidgets('can be closed', (tester) async {
        when(() => stickersBloc.state)
            .thenReturn(StickersState(isDrawerActive: true));
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: DesktopStickersDrawer()),
          ),
        );
        await tester
            .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.pump();
        verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
      });
    });

    group('MobileStickersDrawer', () {
      testWidgets(
          'opens MobileStickersDrawer when '
          'is mobile, is active and is portrait', (tester) async {
        when(() => platformHelper.isMobile).thenReturn(true);
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(isDrawerActive: false),
        );
        tester.setPortraitDisplaySize();

        await tester.pumpApp(
          BlocProvider.value(value: stickersBloc, child: StickersDrawerLayer()),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);

        tester.widget<IconButton>(find.byType(IconButton)).onPressed!();
        await tester.pumpAndSettle();
      });

      testWidgets(
          'opens MobileStickersDrawer when '
          'is not mobile and is portrait', (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(isDrawerActive: false),
        );
        tester.setPortraitDisplaySize();

        await tester.pumpApp(
          BlocProvider.value(value: stickersBloc, child: StickersDrawerLayer()),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);

        tester.widget<IconButton>(find.byType(IconButton)).onPressed!();
        await tester.pumpAndSettle();
      });

      testWidgets('can select stickers on MobileStickersDrawer',
          (tester) async {
        final sticker = Assets.props.first;
        whenListen(
          stickersBloc,
          Stream.fromIterable([
            StickersState(isDrawerActive: true),
          ]),
          initialState: StickersState(isDrawerActive: false),
        );
        await tester.pumpApp(
          BlocProvider.value(value: stickersBloc, child: StickersDrawerLayer()),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
        final stickerChoice =
            tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
        stickerChoice.onPressed();
        await tester.pumpAndSettle();
        verify(() => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)))
            .called(1);
      });

      testWidgets('can close MobileStickersDrawer', (tester) async {
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(isDrawerActive: false),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: StickersDrawerLayer(),
          ),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
        final closeButtonFinder = find.byKey(
          Key('stickersDrawer_close_iconButton'),
        );
        tester.widget<IconButton>(closeButtonFinder).onPressed!();
        await tester.pumpAndSettle();
        expect(find.byType(MobileStickersDrawer), findsNothing);
        verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
      });
    });
  });
}

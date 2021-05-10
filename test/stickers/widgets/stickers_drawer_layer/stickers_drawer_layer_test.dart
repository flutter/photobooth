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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
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
          PhotoboothState(
            stickers: [PhotoAsset(id: '0', asset: sticker)],
          ),
        );
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: stickersBloc),
              BlocProvider.value(value: photoboothBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(
              body: DesktopStickersDrawer(),
            ),
          ),
        );
        await tester
            .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.pumpAndSettle();
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
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
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
        );
        await tester.pumpAndSettle();
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
          Stream.fromIterable([
            StickersState(isDrawerActive: true),
          ]),
          initialState: StickersState(isDrawerActive: false),
        );
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc),
              BlocProvider.value(value: stickersBloc),
            ],
            child: Scaffold(body: Stack(children: [StickersDrawerLayer()])),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
        await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.pumpAndSettle();
        expect(find.byType(MobileStickersDrawer), findsNothing);

        verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
      });
    });
  });
}

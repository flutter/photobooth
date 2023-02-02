// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeStickersEvent());
    registerFallbackValue(FakeStickersState());
    registerFallbackValue(FakePhotoboothEvent());
    registerFallbackValue(FakePhotoboothState());
  });

  group('StickersDrawerLayer', () {
    late PhotoboothBloc photoboothBloc;
    late StickersBloc stickersBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      stickersBloc = MockStickersBloc();
    });

    group('DesktopStickersDrawer', () {
      testWidgets(
          'does not render DesktopStickersDrawer when '
          'drawer is inactive', (tester) async {
        when(() => stickersBloc.state).thenReturn(
          StickersState(),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsNothing);
      });

      testWidgets(
          'renders DesktopStickersDrawer when '
          'width greater than mobile breakpoint and it is drawer active',
          (tester) async {
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: true),
        );
        tester.setLandscapeDisplaySize();
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsOneWidget);
      });

      testWidgets(
          'does not render DesktopStickersDrawer when '
          'width smaller than mobile and it is drawer active', (tester) async {
        when(() => stickersBloc.state).thenReturn(
          StickersState(isDrawerActive: true),
        );
        tester.setSmallDisplaySize();
        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        expect(find.byType(DesktopStickersDrawer), findsNothing);
      });

      testWidgets('adds StickerSelected when StickerChoice tapped',
          (tester) async {
        final sticker = Assets.props.first;
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
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        final stickerChoice =
            tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
        stickerChoice.onPressed();
        await tester.pump();
        verify(
          () => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)),
        ).called(1);
        verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
      });

      testWidgets('adds StickersDrawerTabTapped when tab is selected',
          (tester) async {
        final sticker = Assets.props.first;
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
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        await tester.tap(find.byKey(Key('stickersTabs_eyewearTab')));
        verify(
          () => stickersBloc.add(StickersDrawerTabTapped(index: 2)),
        ).called(1);
      });

      testWidgets('can be closed', (tester) async {
        var onCloseTappedCallCount = 0;
        await tester.pumpApp(
          Scaffold(
            body: DesktopStickersDrawer(
              initialIndex: 0,
              onTabChanged: (_) {},
              onStickerSelected: (_) {},
              onCloseTapped: () => onCloseTappedCallCount++,
              bucket: PageStorageBucket(),
            ),
          ),
        );
        await tester
            .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
        await tester.pump();
        expect(onCloseTappedCallCount, equals(1));
      });
    });

    group('MobileStickersDrawer', () {
      testWidgets(
          'opens MobileStickersDrawer when '
          'is active and width smaller than mobile breakpoint', (tester) async {
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(),
        );
        tester.setSmallDisplaySize();

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
          'does not open MobileStickersDrawer when '
          'width greater than mobile breakpoint', (tester) async {
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(),
        );
        tester.setLandscapeDisplaySize();

        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(
              body: Stack(children: const [StickersDrawerLayer()]),
            ),
          ),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsNothing);

        tester.widget<IconButton>(find.byType(IconButton)).onPressed!();
        await tester.pump();
      });

      testWidgets('can select stickers on MobileStickersDrawer',
          (tester) async {
        final sticker = Assets.props.first;
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(),
        );
        tester.setSmallDisplaySize();

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
        verify(
          () => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)),
        ).called(1);
        expect(find.byType(MobileStickersDrawer), findsNothing);
      });

      testWidgets('can change tabs on MobileStickersDrawer', (tester) async {
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(),
        );
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          BlocProvider.value(
            value: stickersBloc,
            child: Scaffold(body: StickersDrawerLayer()),
          ),
          photoboothBloc: photoboothBloc,
        );
        await tester.pump();
        expect(find.byType(MobileStickersDrawer), findsOneWidget);
        final tabBar = tester.widget<TabBar>(find.byType(TabBar));
        tabBar.onTap!(4);
        verify(
          () => stickersBloc.add(StickersDrawerTabTapped(index: 4)),
        ).called(1);
        final closeButtonFinder = find.byKey(
          Key('stickersDrawer_close_iconButton'),
        );
        tester.widget<IconButton>(closeButtonFinder).onPressed!();
        await tester.pumpAndSettle();
      });

      testWidgets('can close MobileStickersDrawer', (tester) async {
        whenListen(
          stickersBloc,
          Stream.fromIterable([StickersState(isDrawerActive: true)]),
          initialState: StickersState(),
        );
        tester.setSmallDisplaySize();

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

// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() async {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = CameraImage(width: width, height: height, data: data);

  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  setUpAll(() {
    registerFallbackValue<StickersEvent>(FakeStickersEvent());
    registerFallbackValue<StickersState>(FakeStickersState());
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  group('StickersPage', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState(
        image: image,
      ));
    });

    test('is routable', () {
      expect(StickersPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders Android character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(asset: Assets.android)],
          image: image,
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(
        find.byKey(const Key('charactersLayer_android_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Dash character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(asset: Assets.dash)],
          image: image,
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(
        find.byKey(const Key('charactersLayer_dash_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Sparky character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(asset: Assets.sparky)],
          image: image,
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(
        find.byKey(const Key('charactersLayer_sparky_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders StickersView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(find.byType(StickersView), findsOneWidget);
    });
  });

  group('StickersView', () {
    late PhotoboothBloc photoboothBloc;
    late StickersBloc stickersBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );
      stickersBloc = MockStickersBloc();
      when(() => stickersBloc.state).thenReturn(StickersState());
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets('does not render StickersDrawer when mode is inactive',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(StickersDrawer), findsNothing);
    });

    testWidgets('renders StickersDrawer when drawer is active', (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(StickersDrawer), findsOneWidget);
    });

    testWidgets('adds StickersDrawerToggled when close button is tapped',
        (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(StickersDrawer), findsOneWidget);
      await tester
          .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.pumpAndSettle();
      verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
    });

    testWidgets('adds StickersDrawerToggled when OpenStickersButton tapped',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      tester
          .widget<OpenStickersButton>(find.byType(OpenStickersButton))
          .onPressed();
      verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
    });

    testWidgets(
        'does not display DraggableResizableAsset when stickers is empty',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(DraggableResizableAsset), findsNothing);
    });

    testWidgets('displays DraggableResizableAsset when stickers is populated',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [
            PhotoAsset(asset: Assets.banana),
            PhotoAsset(asset: Assets.beret)
          ],
          image: image,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(DraggableResizableAsset), findsNWidgets(2));
    });

    testWidgets('adds PhotoStickerTapped when StickerChoice tapped',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(2500, 2500);
      final sticker = Assets.banana;
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(asset: sticker)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      final stickerChoice =
          tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
      stickerChoice.onPressed();
      verify(
        () => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)),
      ).called(1);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('tapping on back button pops route', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(Builder(
        builder: (context) {
          return ElevatedButton(
            key: initialPage,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: photoboothBloc),
                    BlocProvider.value(value: stickersBloc),
                  ],
                  child: StickersView(),
                ),
              ),
            ),
            child: const SizedBox(),
          );
        },
      ));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final backButton = tester.widget<RetakeButton>(find.byType(RetakeButton));
      backButton.onPressed();
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsNothing);
      expect(find.byKey(initialPage), findsOneWidget);
    });

    testWidgets('tapping preview button routes to SharePage', (tester) async {
      await tester.pumpApp(
        StickersPage(),
        photoboothBloc: photoboothBloc,
      );

      final goToPreviewButton =
          tester.widget<NextButton>(find.byType(NextButton));
      goToPreviewButton.onPressed();
      await tester.pumpAndSettle();

      expect(find.byType(StickersPage), findsNothing);
      expect(find.byType(SharePage), findsOneWidget);
    });

    testWidgets('does not display ClearStickersButton when stickers is empty',
        (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(ClearStickersButton), findsNothing);
    });

    testWidgets('displays ClearStickersButton when stickers is not empty',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(asset: Assets.banana)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(ClearStickersButton), findsOneWidget);
    });

    testWidgets(
        'adds PhotoClearStickersTapped when ClearStickersButton is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(asset: Assets.banana)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      final clearStickersButton = tester.widget<ClearStickersButton>(
        find.byType(ClearStickersButton),
      );
      clearStickersButton.onPressed();
      verify(() => photoboothBloc.add(PhotoClearStickersTapped())).called(1);
    });
  });
}

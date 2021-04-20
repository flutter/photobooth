// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class FakeDragUpdate extends Fake implements DragUpdate {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() async {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList(transparentImage);
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
          characters: [PhotoAsset(id: 0, asset: Assets.android)],
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
          characters: [PhotoAsset(id: 0, asset: Assets.dash)],
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
          characters: [PhotoAsset(id: 0, asset: Assets.sparky)],
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
    testWidgets('renders FlutterIconLink', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(FlutterIconLink), findsOneWidget);
    });

    testWidgets('renders FirebaseIconLink', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(FirebaseIconLink), findsOneWidget);
    });
    testWidgets('renders StickersDrawerLayer when mode is active',
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
      expect(find.byType(StickersDrawerLayer), findsOneWidget);
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
            PhotoAsset(id: 0, asset: Assets.banana),
            PhotoAsset(id: 1, asset: Assets.beret)
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

    testWidgets('adds PhotoStickerDragged when sticker dragged',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
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

      tester
          .widget<DraggableResizableAsset>(find.byType(DraggableResizableAsset))
          .onUpdate
          ?.call(FakeDragUpdate());
      verify(
        () => photoboothBloc.add(any(that: isA<PhotoStickerDragged>())),
      ).called(1);
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
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
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
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
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

    testWidgets('opens MobileStickersDrawer when is mobile and is active',
        (tester) async {
      whenListen(
        stickersBloc,
        Stream.fromIterable([StickersState(isDrawerActive: true)]),
        initialState: StickersState(isDrawerActive: false),
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
      await tester.pumpAndSettle();
      expect(find.byType(MobileStickersDrawer), findsOneWidget);
    });

    testWidgets('can select stickers on MobileStickersDrawer', (tester) async {
      final sticker = Assets.banana;
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
          child: StickersView(),
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
          child: StickersView(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MobileStickersDrawer), findsOneWidget);
      await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.pumpAndSettle();
      expect(find.byType(MobileStickersDrawer), findsNothing);

      verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
    });

    testWidgets('adds PhotoTapped when background photo is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
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
      final background = tester.widget<GestureDetector>(
        find.byKey(const Key('stickersView_background_gestureDetector')),
      );
      background.onTap?.call();
      verify(() => photoboothBloc.add(PhotoTapped())).called(1);
    });

    testWidgets('adds PhotoStickerRemoved when sticker selected is removed',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
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

      tester
          .widget<DraggableResizableAsset>(find.byType(DraggableResizableAsset))
          .onDelete
          ?.call();

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoStickerRemoved>())),
      ).called(1);
    });
  });
}

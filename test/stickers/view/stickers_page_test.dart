// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class FakeShareEvent extends Fake implements ShareEvent {}

class FakeShareState extends Fake implements ShareState {}

class MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class FakeDragUpdate extends Fake implements DragUpdate {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const width = 1;
  const height = 1;
  final data = 'data:image/png,${base64.encode(transparentImage)}';
  final image = CameraImage(width: width, height: height, data: data);

  setUpAll(() {
    registerFallbackValue(FakeStickersEvent());
    registerFallbackValue(FakeStickersState());
    registerFallbackValue(FakePhotoboothEvent());
    registerFallbackValue(FakePhotoboothState());
    registerFallbackValue(FakeShareEvent());
    registerFallbackValue(FakeShareState());
  });

  group('StickersPage', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          image: image,
        ),
      );
    });

    test('is routable', () {
      expect(StickersPage.route(), isA<MaterialPageRoute<void>>());
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

    testWidgets('renders PhotoboothBackground', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(PhotoboothBackground), findsOneWidget);
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
        'does not display pulse animation '
        'once has been clicked', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(AnimatedPulse), findsOneWidget);
      tester
          .widget<AppTooltipButton>(
            find.byKey(Key('stickersView_openStickersButton_appTooltipButton')),
          )
          .onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedPulse), findsNothing);
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
      expect(find.byType(DraggableResizable), findsNothing);
    });

    testWidgets('displays DraggableResizableAsset when stickers is populated',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [
            PhotoAsset(id: '0', asset: Assets.props.first),
            PhotoAsset(id: '1', asset: Assets.props.last)
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
      expect(find.byType(DraggableResizable), findsNWidgets(2));
    });

    testWidgets('adds PhotoStickerDragged when sticker dragged',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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
          .widget<DraggableResizable>(find.byType(DraggableResizable))
          .onUpdate
          ?.call(FakeDragUpdate());
      verify(
        () => photoboothBloc.add(any(that: isA<PhotoStickerDragged>())),
      );
    });

    testWidgets('tapping on retake + close does nothing', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              key: initialPage,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
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
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<IconButton>(find.byType(IconButton)).onPressed!();

      await tester.pumpAndSettle();

      verifyNever(() => photoboothBloc.add(const PhotoClearAllTapped()));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);
    });

    testWidgets('tapping on retake + cancel does nothing', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              key: initialPage,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
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
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed!();

      await tester.pumpAndSettle();

      verifyNever(() => photoboothBloc.add(const PhotoClearAllTapped()));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);
    });

    testWidgets(
        'tapping on retake + confirm replaces route with PhotoboothPage'
        ' and clears props', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(PhotoboothPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed!();

      await tester.pumpAndSettle();

      verify(() => photoboothBloc.add(const PhotoClearAllTapped())).called(1);
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsNothing);
      expect(find.byType(PhotoboothPage), findsOneWidget);
    });

    testWidgets('tapping next + cancel does not route to SharePage',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed!();

      await tester.pump();
      await tester.pump();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(SharePage), findsNothing);
    });

    testWidgets('tapping next + close does not route to SharePage',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<IconButton>(find.byType(IconButton)).onPressed!();

      await tester.pump();
      await tester.pump();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(SharePage), findsNothing);
    });

    testWidgets('tapping next + confirm routes to SharePage', (tester) async {
      final photosRepository = MockPhotosRepository();
      when(
        () => photosRepository.composite(
          width: any(named: 'width'),
          height: any(named: 'height'),
          data: any(named: 'data'),
          layers: [],
          aspectRatio: any(named: 'aspectRatio'),
        ),
      ).thenAnswer((_) async => Uint8List(0));

      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
        photosRepository: photosRepository,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed!();

      await tester.pump();
      await tester.pump();

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
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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

    testWidgets('shows ClearStickersDialog when ClearStickersButton is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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
      await tester.pump();
      expect(find.byType(ClearStickersDialog), findsOneWidget);
    });

    testWidgets(
        'PhotoClearStickersTapped when ClearStickersConfirmButton is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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
      final clearStickersButton = tester.widget<ClearStickersButton>(
        find.byType(ClearStickersButton),
      );
      clearStickersButton.onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(ClearStickersDialog), findsOneWidget);
      final confirmButton = find.byType(ClearStickersConfirmButton);
      await tester.ensureVisible(confirmButton);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      verify(() => photoboothBloc.add(PhotoClearStickersTapped())).called(1);
    });

    testWidgets('adds PhotoTapped when background photo is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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

    testWidgets(
        'adds PhotoDeleteSelectedStickerTapped '
        'when sticker selected is removed', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: Assets.props.first)],
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
          .widget<DraggableResizable>(find.byType(DraggableResizable))
          .onDelete
          ?.call();

      verify(
        () => photoboothBloc.add(
          any(that: isA<PhotoDeleteSelectedStickerTapped>()),
        ),
      ).called(1);
    });

    testWidgets(
        'renders StickersCaption when shouldDisplayPropsReminder is true',
        (tester) async {
      when(() => stickersBloc.state).thenReturn(StickersState());
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(
        find.byKey(const Key('stickersPage_propsReminder_appTooltip')),
        findsOneWidget,
      );
    });

    testWidgets(
        'does not render StickersCaption when '
        'shouldDisplayPropsReminder is false', (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(shouldDisplayPropsReminder: false),
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
      expect(
        find.byKey(const Key('stickersPage_propsReminder_appTooltip')),
        findsNothing,
      );
    });
  });
}

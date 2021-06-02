// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class FakeCameraOptions extends Fake implements CameraOptions {}

class MockImage extends Mock implements ui.Image {}

class MockCameraImage extends Mock implements CameraImage {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class FakeDragUpdate extends Fake implements DragUpdate {}

void main() {
  setUpAll(() {
    registerFallbackValue<CameraOptions>(FakeCameraOptions());
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
    registerFallbackValue<DragUpdate>(FakeDragUpdate());
  });

  const cameraId = 1;
  late CameraPlatform cameraPlatform;
  late CameraImage cameraImage;

  setUp(() {
    cameraImage = MockCameraImage();
    cameraPlatform = MockCameraPlatform();
    CameraPlatform.instance = cameraPlatform;
    when(() => cameraImage.width).thenReturn(4);
    when(() => cameraImage.height).thenReturn(3);
    when(() => cameraPlatform.init()).thenAnswer((_) async => {});
    when(
      () => cameraPlatform.create(any()),
    ).thenAnswer((_) async => cameraId);
    when(() => cameraPlatform.play(any())).thenAnswer((_) async => {});
    when(() => cameraPlatform.stop(any())).thenAnswer((_) async => {});
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => {});
    when(() => cameraPlatform.takePicture(any()))
        .thenAnswer((_) async => cameraImage);
  });

  group('PhotoboothPage', () {
    test('is routable', () {
      expect(PhotoboothPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('displays a PhotoboothView', (tester) async {
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothView), findsOneWidget);
    });
  });

  group('PhotoboothView', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders Camera', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      expect(find.byType(Camera), findsOneWidget);
    });

    testWidgets('renders placeholder when initializing', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraUnknownException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets(
        'renders camera access denied error '
        'when cameraPlatform throws CameraNotAllowed exception',
        (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotAllowedException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_cameraAccessDenied')),
        findsOneWidget,
      );
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets(
        'renders camera not found error '
        'when cameraPlatform throws CameraNotFound exception', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotFoundException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_cameraNotFound')),
        findsOneWidget,
      );
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets(
        'renders camera not supported error '
        'when cameraPlatform throws CameraNotSupported exception',
        (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotSupportedException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_cameraNotSupported')),
        findsOneWidget,
      );
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets(
        'renders unknown error '
        'when cameraPlatform throws CameraUnknownException exception',
        (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraUnknownException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_unknown')),
        findsOneWidget,
      );
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets('renders error when not allowed', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotAllowedException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
      verifyNever(() => cameraPlatform.play(any()));
    });

    testWidgets('renders preview when available', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders landscape camera when orientation is landscape',
        (tester) async {
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 400));
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(PhotoboothAspectRatio.landscape));
    });

    testWidgets(
        'adds PhotoCaptured with landscape aspect ratio '
        'when photo is snapped', (tester) async {
      const preview = SizedBox();
      final image = CameraImage(
        data: 'data:image/png,${base64.encode(transparentImage)}',
        width: 1280,
        height: 720,
      );
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 400));
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(
        () => cameraPlatform.takePicture(cameraId),
      ).thenAnswer((_) async => image);
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );

      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );

      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();

      verify(
        () => photoboothBloc.add(
          PhotoCaptured(
            aspectRatio: PhotoboothAspectRatio.landscape,
            image: image,
          ),
        ),
      ).called(1);
    });

    testWidgets('renders portrait camera when orientation is portrait',
        (tester) async {
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(PhotoboothAspectRatio.portrait));
    });

    testWidgets(
        'adds PhotoCaptured with portrait aspect ratio '
        'when photo is snapped', (tester) async {
      const preview = SizedBox();
      final image = CameraImage(
        data: 'data:image/png,${base64.encode(transparentImage)}',
        width: 1280,
        height: 720,
      );
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(
        () => cameraPlatform.takePicture(cameraId),
      ).thenAnswer((_) async => image);
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );

      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );

      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();
      verify(
        () => photoboothBloc.add(
          PhotoCaptured(
            aspectRatio: PhotoboothAspectRatio.portrait,
            image: image,
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to StickersPage when photo is taken',
        (tester) async {
      const preview = SizedBox();
      final image = CameraImage(
        data: 'data:image/png,${base64.encode(transparentImage)}',
        width: 1280,
        height: 720,
      );
      tester.setDisplaySize(const Size(2500, 2500));
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(
        () => cameraPlatform.takePicture(cameraId),
      ).thenAnswer((_) async => image);
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );

      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );

      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();

      expect(find.byType(StickersPage), findsOneWidget);
    });
  });

  group('PhotoboothPreview', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders dash, sparky, dino, and android buttons',
        (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CharacterIconButton), findsNWidgets(4));
    });

    testWidgets('renders FlutterIconLink', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FlutterIconLink), findsOneWidget);
    });

    testWidgets('renders FirebaseIconLink', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FirebaseIconLink), findsOneWidget);
    });

    testWidgets('renders only android when only android is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedAndroid), findsOneWidget);
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders only dash when only dash is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        findsOneWidget,
      );
      expect(find.byType(AnimatedDash), findsOneWidget);
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders only sparky when only sparky is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [
            PhotoAsset(id: '0', asset: Assets.sparky),
          ],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedSparky), findsOneWidget);
    });

    testWidgets('renders only dino when only dino is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dino)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_dino_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedDino), findsOneWidget);
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.sparky)],
        ),
      );
      const preview = SizedBox();

      tester.setDisplaySize(Size(2500, 2500));
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders dash, sparky, dino, and android when all are selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: const [
          PhotoAsset(id: '0', asset: Assets.android),
          PhotoAsset(id: '1', asset: Assets.dash),
          PhotoAsset(id: '2', asset: Assets.sparky),
          PhotoAsset(id: '3', asset: Assets.dino),
        ]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(find.byType(DraggableResizable), findsNWidgets(4));
      expect(find.byType(AnimatedAndroid), findsOneWidget);
      expect(find.byType(AnimatedDash), findsOneWidget);
      expect(find.byType(AnimatedDino), findsOneWidget);
      expect(find.byType(AnimatedSparky), findsOneWidget);
    });

    testWidgets(
        'displays a LandscapeCharactersIconLayout '
        'when orientation is landscape', (tester) async {
      tester.setDisplaySize(landscapeDisplaySize);
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(
            preview: preview,
            onSnapPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LandscapeCharactersIconLayout), findsOneWidget);
    });

    testWidgets(
        'displays a PortraitCharactersIconLayout '
        'when orientation is portrait', (tester) async {
      tester.setDisplaySize(portraitDisplaySize);
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PortraitCharactersIconLayout), findsOneWidget);
    });

    testWidgets('tapping on dash button adds PhotoCharacterToggled',
        (tester) async {
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_dash_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.dash),
        ),
      ).called(1);
    });

    testWidgets('tapping on sparky button adds PhotoCharacterToggled',
        (tester) async {
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_sparky_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.sparky),
        ),
      ).called(1);
    });

    testWidgets('tapping on android button adds PhotoCharacterToggled',
        (tester) async {
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_android_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.android),
        ),
      ).called(1);
    });

    testWidgets('tapping on dino button adds PhotoCharacterToggled',
        (tester) async {
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_dino_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.dino),
        ),
      ).called(1);
    });

    testWidgets('tapping on background adds PhotoTapped', (tester) async {
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothPreview_background_gestureDetector'),
      ));
      expect(tester.takeException(), isNull);
      verify(() => photoboothBloc.add(PhotoTapped())).called(1);
    });

    testWidgets(
        'renders CharactersCaption on mobile when no character is selected',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CharactersCaption), findsOneWidget);
    });

    testWidgets(
        'does not render CharactersCaption on mobile when '
        'any character is selected', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      when(() => photoboothBloc.state).thenReturn(PhotoboothState(
        characters: const [PhotoAsset(id: '0', asset: Assets.android)],
      ));
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();
      expect(find.byType(CharactersCaption), findsNothing);
    });
  });
}

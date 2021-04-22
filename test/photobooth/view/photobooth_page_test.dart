// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/common/common.dart';
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

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

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

    testWidgets('renders placholder when initializing', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      expect(find.byType(PhotoboothPlaceholder), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraUnknownException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
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
    });

    testWidgets('renders error when not allowed', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotAllowedException());
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
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

    testWidgets('renders 4/3 aspect ratio on desktop', (tester) async {
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());

      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(4 / 3));
    });

    testWidgets('renders 3/4 aspect ratio on mobile', (tester) async {
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(3 / 4));
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('navigates to StickersPage when photo is taken',
        (tester) async {
      const preview = SizedBox();
      final image = CameraImage(
        data: Uint8List.fromList(transparentImage),
        width: 1280,
        height: 720,
      );
      tester.binding.window.physicalSizeTestValue = const Size(2500, 2500);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(
        () => cameraPlatform.takePicture(cameraId),
      ).thenAnswer((_) async => image);
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );

      await tester.runAsync(() async {
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        await tester.pump();

        await tester.tap(find.byType(CameraButton));
        await tester.pumpAndSettle();

        expect(find.byType(StickersPage), findsOneWidget);

        final retakeButton = tester.widget<RetakeButton>(
          find.byType(RetakeButton),
        );
        retakeButton.onPressed();
        await tester.pumpAndSettle();
        expect(find.byType(PhotoboothView), findsOneWidget);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      });
    });
  });

  group('PhotoboothPreview', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders dash, sparky, and android buttons', (tester) async {
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

      expect(find.byType(CharacterIconButton), findsNWidgets(3));
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
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.android)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.android)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders only dash when only dash is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.dash)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.dash)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders only sparky when only sparky is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.sparky)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [PhotoAsset(id: 0, asset: Assets.sparky)]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
    });

    testWidgets('renders dash, sparky, and android when all are selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(characters: [
          PhotoAsset(id: 0, asset: Assets.android),
          PhotoAsset(id: 1, asset: Assets.dash),
          PhotoAsset(id: 2, asset: Assets.sparky),
        ]),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DraggableResizableAsset), findsNWidgets(3));
    });

    testWidgets('displays a DesktopCharactersIconLayout', (tester) async {
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
      expect(find.byType(DesktopCharactersIconLayout), findsOneWidget);
    });

    testWidgets('displays a MobileCharactersIconLayout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MobileCharactersIconLayout), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
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
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
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
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets(
        'does not render CharactersCaption on mobile when '
        'any character is selected', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      when(() => photoboothBloc.state).thenReturn(PhotoboothState(
        characters: [PhotoAsset(id: 0, asset: Assets.android)],
      ));
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CharactersCaption), findsNothing);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}

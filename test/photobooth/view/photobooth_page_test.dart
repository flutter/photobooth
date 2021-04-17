// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

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

    test('route name is PhotoboothPage', () {
      expect(PhotoboothPage.route().settings.name, 'PhotoboothPage');
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
      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      expect(find.byType(Camera), findsOneWidget);
    });

    testWidgets('renders placholder when initializing', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      expect(find.byType(PhotoboothPlaceholder), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraUnknownException());
      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets('renders error when not allowed', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotAllowedException());
      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets('renders preview when available', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders dash, sparky, and android buttons', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CharacterIconButton), findsNWidgets(3));
    });

    testWidgets('renders only android when only android is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          android: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoboothAndroidUpdated when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          android: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoboothAndroidUpdated>())),
      ).called(1);
    });

    testWidgets('renders only dash when only dash is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          dash: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoboothDashUpdated when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          dash: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoboothDashUpdated>())),
      ).called(1);
    });

    testWidgets('renders only sparky when only sparky is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          sparky: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds PhotoboothSparkyUpdated when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          sparky: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        Offset(10, 10),
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoboothSparkyUpdated>())),
      ).called(1);
    });

    testWidgets('renders dash, sparky, and android when all are selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          android: CharacterAsset(isSelected: true),
          dash: CharacterAsset(isSelected: true),
          sparky: CharacterAsset(isSelected: true),
        ),
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DraggableResizableAsset), findsNWidgets(3));
    });

    testWidgets('displays a DesktopCharactersIconLayout', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DesktopCharactersIconLayout), findsOneWidget);
    });

    testWidgets('displays a MobileCharactersIconLayout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MobileCharactersIconLayout), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('tapping on dash button adds DashToggled', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_dash_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(() => photoboothBloc.add(PhotoboothDashToggled())).called(1);
    });

    testWidgets('tapping on sparky button adds SparkyToggled', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_sparky_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(() => photoboothBloc.add(PhotoboothSparkyToggled())).called(1);
    });

    testWidgets('tapping on android button adds AndroidToggled',
        (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(
        const Key('photoboothView_android_characterIconButton'),
      ));
      expect(tester.takeException(), isNull);
      verify(() => photoboothBloc.add(PhotoboothAndroidToggled())).called(1);
    });

    testWidgets('navigates to DecorationPage when photo is taken',
        (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
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

      await tester.runAsync(() async {
        await tester.pumpApp(
          BlocProvider.value(value: photoboothBloc, child: PhotoboothView()),
        );
        await tester.pumpAndSettle();
        await tester.pump();

        await tester.tap(find.byType(CameraButton));
        await tester.pumpAndSettle();
        expect(find.byType(DecorationPage), findsOneWidget);

        final decorationPage = tester.widget<DecorationPage>(
          find.byType(DecorationPage),
        );
        expect(decorationPage.image, isNotNull);
        expect(find.byType(DecorationPage), findsOneWidget);

        await tester.tap(find.byType(RetakeButton));
        await tester.pumpAndSettle();
        expect(find.byType(PhotoboothView), findsOneWidget);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      });
    });
  });
}

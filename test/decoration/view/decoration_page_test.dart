// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';

class FakeDecorationEvent extends Fake implements DecorationEvent {}

class FakeDecorationState extends Fake implements DecorationState {}

class MockDecorationBloc extends MockBloc<DecorationEvent, DecorationState>
    implements DecorationBloc {}

void main() async {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = CameraImage(width: width, height: height, data: data);

  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  setUpAll(() {
    registerFallbackValue<DecorationEvent>(FakeDecorationEvent());
    registerFallbackValue<DecorationState>(FakeDecorationState());
  });

  group('DecorationPage', () {
    test('is routable', () {
      expect(
        DecorationPage.route(image: image, state: PhotoboothState()),
        isA<MaterialPageRoute>(),
      );
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(
        DecorationPage(image: image, state: PhotoboothState()),
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders Android character assert', (tester) async {
      await tester.pumpApp(
        DecorationPage(
          image: image,
          state: PhotoboothState(
            android: CharacterAsset.android().copyWith(isSelected: true),
          ),
        ),
      );
      expect(
        find.byKey(const Key('decorationPage_android_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Dash character assert', (tester) async {
      await tester.pumpApp(
        DecorationPage(
          image: image,
          state: PhotoboothState(
            dash: CharacterAsset.dash().copyWith(isSelected: true),
          ),
        ),
      );
      expect(
        find.byKey(const Key('decorationPage_dash_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Sparky character assert', (tester) async {
      await tester.pumpApp(
        DecorationPage(
          image: image,
          state: PhotoboothState(
            sparky: CharacterAsset.sparky().copyWith(isSelected: true),
          ),
        ),
      );
      expect(
        find.byKey(const Key('decorationPage_sparky_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders DecorationView', (tester) async {
      await tester.pumpApp(
        DecorationPage(image: image, state: PhotoboothState()),
      );
      expect(find.byType(DecorationView), findsOneWidget);
    });
  });

  testWidgets('tapping on back button pops route', (tester) async {
    const initialPage = Key('__target__');
    await tester.pumpApp(Builder(
      builder: (context) {
        return ElevatedButton(
          key: initialPage,
          onPressed: () => Navigator.of(context).push(
            DecorationPage.route(image: image, state: PhotoboothState()),
          ),
          child: const SizedBox(),
        );
      },
    ));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(DecorationPage), findsOneWidget);
    expect(find.byKey(initialPage), findsNothing);

    final backButtonFinder = find.byKey(
      const Key('decorationPage_back_iconButton'),
    );
    await tester.ensureVisible(backButtonFinder);
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
    await tester.pump();

    expect(find.byType(DecorationPage), findsNothing);
    expect(find.byKey(initialPage), findsOneWidget);
  });

  testWidgets('tapping preview button routes to PreviewPage', (tester) async {
    await tester.pumpApp(
      DecorationPage(image: image, state: PhotoboothState()),
    );

    final goToPreviewButton = find.byKey(
      const Key('decorationPage_preview_floatingActionButton'),
    );
    await tester.ensureVisible(goToPreviewButton);
    await tester.tap(goToPreviewButton);
    await tester.pumpAndSettle();

    expect(find.byType(DecorationPage), findsNothing);
    expect(find.byType(PreviewPage), findsOneWidget);
  });

  group('DecorationView', () {
    late DecorationBloc decorationBloc;

    setUp(() {
      decorationBloc = MockDecorationBloc();
      when(() => decorationBloc.state).thenReturn(DecorationState());
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets('does not render StickerCarousel when mode is inactive',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      expect(find.byType(StickersCarousel), findsNothing);
    });

    testWidgets('renders StickerCarousel when mode is active', (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(mode: DecorationMode.active),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      expect(find.byType(StickersCarousel), findsOneWidget);
    });

    testWidgets('adds DecorationModeToggled when OpenStickersButton tapped',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      await tester.ensureVisible(find.byType(OpenStickersButton));
      await tester.tap(find.byType(OpenStickersButton));
      verify(() => decorationBloc.add(DecorationModeToggled())).called(1);
    });

    testWidgets(
        'does not display DraggableResizableAsset when stickers is empty',
        (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(mode: DecorationMode.active, stickers: []),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      expect(find.byType(DraggableResizableAsset), findsNothing);
    });

    testWidgets('displays DraggableResizableAsset when stickers is populated',
        (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(
          mode: DecorationMode.active,
          stickers: [Assets.dash, Assets.dash],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      expect(find.byType(DraggableResizableAsset), findsNWidgets(2));
    });

    testWidgets('adds DecorationStickerSelected when StickerChoice tapped',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(2500, 2500);
      final sticker = Assets.dash;
      when(() => decorationBloc.state).thenReturn(
        DecorationState(mode: DecorationMode.active, stickers: [sticker]),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: DecorationView()),
      );
      await tester.tap(find.byType(StickerChoice));
      verify(
        () => decorationBloc.add(DecorationStickerSelected(sticker: sticker)),
      ).called(1);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}

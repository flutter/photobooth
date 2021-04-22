// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = CameraImage(width: width, height: height, data: data);

  late PhotoboothBloc photoboothBloc;
  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());

    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));

    shareBloc = MockShareBloc();
    whenListen(
      shareBloc,
      Stream.fromIterable([ShareState.initial()]),
      initialState: ShareState.initial(),
    );
  });

  group('SharePage', () {
    test('is routable', () {
      expect(SharePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_retake_elevatedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_share_elevatedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_download_outlinedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays white footer', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byType(WhiteFooter),
        findsOneWidget,
      );
    });

    testWidgets('displays a social media share clarification note',
        (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_socialMediaShareClarification_text')),
        findsOneWidget,
      );
    });

    testWidgets('displays selected character assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.android)],
          image: image,
        ),
      );
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_android_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('displays selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.android)],
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
          image: image,
        ),
      );
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_0_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('displays multiple selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.android)],
          stickers: [
            PhotoAsset(id: 0, asset: Assets.banana),
            PhotoAsset(id: 1, asset: Assets.banana),
            PhotoAsset(id: 2, asset: Assets.beret),
          ],
          image: image,
        ),
      );
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_0_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_banana_1_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_beret_2_positioned')),
        findsOneWidget,
      );
    });
  });

  group('DownloadButton', () {
    testWidgets('tapping on download photo button completes', (tester) async {
      final downloadButtonFinder = find.byKey(
        const Key('sharePage_download_outlinedButton'),
      );
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      await tester.ensureVisible(downloadButtonFinder);
      await tester.tap(downloadButtonFinder);

      expect(tester.takeException(), isNull);
    });
  });

  group('RetakeButton', () {
    testWidgets('tapping on retake button goes back to PhotoboothPage',
        (tester) async {
      const photoboothPage = Key('photoboothPage');
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SizedBox(key: photoboothPage),
                    settings: RouteSettings(name: PhotoboothPage.name),
                  ),
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SizedBox(),
                    settings: RouteSettings(name: 'IntermediatePage'),
                  ),
                );

                Navigator.of(context).push(SharePage.route());
              },
              child: const SizedBox(),
            );
          },
        ),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SharePage), findsOneWidget);

      final retakeButtonFinder = find.byKey(
        const Key('sharePage_retake_elevatedButton'),
      );
      await tester.ensureVisible(retakeButtonFinder);
      await tester.tap(retakeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(SharePage), findsNothing);
      expect(find.byKey(photoboothPage), findsOneWidget);

      verify(() => photoboothBloc.add(PhotoClearAllTapped())).called(1);
    });
  });

  group('ResponsiveLayout', () {
    testWidgets('displays a DesktopButtonsLayout', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(DesktopButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a MobileButtonsLayout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      await tester.pumpApp(
        SharePage(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(MobileButtonsLayout), findsOneWidget);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}

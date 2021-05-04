// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  late PhotosRepository photosRepository;
  late PhotoboothBloc photoboothBloc;
  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());

    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    photosRepository = MockPhotosRepository();
    when(
      () => photosRepository.composite(
        width: width,
        height: height,
        data: data,
        layers: [],
        aspectRatio: any(named: 'aspectRatio'),
      ),
    ).thenAnswer((_) async => Uint8List.fromList([]));
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));

    shareBloc = MockShareBloc();
    whenListen(
      shareBloc,
      Stream.fromIterable([ShareState()]),
      initialState: ShareState(),
    );
  });

  group('SharePage', () {
    test('is routable', () {
      expect(SharePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a ShareView', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photosRepository: photosRepository,
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareView), findsOneWidget);
    });
  });

  group('ShareView', () {
    testWidgets('displays a ShareBackground', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoIndicator', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(AnimatedPhotoIndicator), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoboothPhoto', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(AnimatedPhotoboothPhoto), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byType(ShareButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('downloadButton_download_outlinedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a GoToGoogleIOButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_goToGoogleIO_elevatedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays white footer', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byType(WhiteFooter),
        findsOneWidget,
      );
    });

    group('GoToGoogleIOButton', () {
      testWidgets('opens link when tapped', (tester) async {
        final mock = MockUrlLauncher();
        const url = googleIOExternalLink;
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launch(
              url,
              useSafariVC: true,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: false,
              headers: const {},
            )).thenAnswer((_) async => true);
        final googleIOButton = find.byKey(
          const Key('sharePage_goToGoogleIO_elevatedButton'),
        );
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );

        await tester.ensureVisible(googleIOButton);
        await tester.tap(googleIOButton);
        await tester.pumpAndSettle();

        verify(
          () => mock.launch(
            url,
            useSafariVC: true,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          ),
        ).called(1);
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

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ShareView()),
                  );
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

        expect(find.byType(ShareView), findsOneWidget);

        final backButton =
            tester.widget<RetakeButton>(find.byType(RetakeButton));
        backButton.onPressed();
        await tester.pumpAndSettle();

        expect(find.byType(ShareView), findsNothing);
        expect(find.byKey(photoboothPage), findsOneWidget);

        verify(() => photoboothBloc.add(PhotoClearAllTapped())).called(1);
      });
    });

    group('ResponsiveLayout', () {
      testWidgets('displays a DesktopButtonsLayout', (tester) async {
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );
        expect(find.byType(DesktopButtonsLayout), findsOneWidget);
      });

      testWidgets('displays a MobileButtonsLayout', (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(
          PhotoboothBreakpoints.small,
          1000,
        );
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );
        expect(find.byType(MobileButtonsLayout), findsOneWidget);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      });
    });
  });
}

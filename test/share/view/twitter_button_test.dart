// ignore_for_file: prefer_const_constructors
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockPhotoAsset extends Mock implements PhotoAsset {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);
  const imageId = 'image-name';
  const shareText =
      '''Check out my photo taken at the #IOPhotoBooth. Join the fun at #GoogleIO and take your own!''';
  final characters = [MockPhotoAsset()];
  final stickers = [MockPhotoAsset()];
  final photoboothState = PhotoboothState(
    image: image,
    characters: characters,
    stickers: stickers,
  );

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
    when(() => photoboothBloc.state).thenReturn(
      PhotoboothState(
        image: image,
        imageId: imageId,
        characters: characters,
        stickers: stickers,
      ),
    );

    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState.initial());
  });

  group('TwitterButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        TwitterButton(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(TwitterButton), findsOneWidget);
    });

    testWidgets('pops when tapped', (tester) async {
      await tester.pumpApp(
        TwitterButton(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      expect(find.byType(TwitterButton), findsNothing);
    });

    testWidgets('adds ShareOnFacebook event when tapped', (tester) async {
      await tester.pumpApp(
        TwitterButton(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      verify(
        () => shareBloc.add(
          ShareOnTwitter(
            image: image,
            imageId: imageId,
            assets: photoboothState.assets,
            shareText: shareText,
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'does not add ShareOnFacebook event '
        'when tapped but PhotoboothState image is null', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          image: null,
          imageId: imageId,
          characters: characters,
          stickers: stickers,
        ),
      );
      await tester.pumpApp(
        TwitterButton(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      verifyNever(() => shareBloc.add(any()));
    });
  });
}

// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockPhotoAsset extends Mock implements PhotoAsset {}

void main() {
  const shareText =
      '''Check out my photo taken at the #IOPhotoBooth. Join the fun at #GoogleIO and take your own!''';
  const shareUrl = 'http://share-url.com';
  final bytes = Uint8List.fromList([]);

  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareInitial());
  });

  group('TwitterButton', () {
    testWidgets('pops when tapped', (tester) async {
      await tester.pumpApp(TwitterButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      expect(find.byType(TwitterButton), findsNothing);
    });

    testWidgets('adds ShareOnTwitterTapped event when tapped', (tester) async {
      await tester.pumpApp(TwitterButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      verify(
        () => shareBloc.add(ShareOnTwitterTapped(shareText: shareText)),
      ).called(1);
    });

    testWidgets(
        'does not add ShareOnTwitterTapped event '
        'when tapped but state is ShareUploadSuccess', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareOnTwitterSuccess(
          file: XFile.fromData(bytes),
          bytes: bytes,
          twitterShareUrl: shareUrl,
          facebookShareUrl: shareUrl,
        ),
      );
      await tester.pumpApp(TwitterButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();

      verifyNever(() => shareBloc.add(any()));
    });
  });
}

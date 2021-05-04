// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

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

  group('FacebookButton', () {
    testWidgets('pops when tapped', (tester) async {
      await tester.pumpApp(FacebookButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();

      expect(find.byType(FacebookButton), findsNothing);
    });

    testWidgets('adds ShareOnFacebook event when tapped', (tester) async {
      await tester.pumpApp(FacebookButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();

      verify(
        () => shareBloc.add(ShareOnFacebookTapped(shareText: shareText)),
      ).called(1);
    });

    testWidgets(
        'does not add ShareOnFacebook event '
        'when tapped but state is ShareUploadSuccess', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareOnTwitterSuccess(
          file: XFile.fromData(bytes),
          bytes: bytes,
          twitterShareUrl: shareUrl,
          facebookShareUrl: shareUrl,
        ),
      );
      await tester.pumpApp(FacebookButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();

      verifyNever(() => shareBloc.add(any()));
    });
  });
}

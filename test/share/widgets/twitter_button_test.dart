// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockPhotoAsset extends Mock implements PhotoAsset {}

void main() {
  const shareUrl = 'http://share-url.com';
  final bytes = Uint8List.fromList([]);

  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue(FakeShareEvent());
    registerFallbackValue(FakeShareState());
  });

  setUp(() {
    shareBloc = MockShareBloc();
    when(() => shareBloc.state).thenReturn(ShareState());
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

      verify(() => shareBloc.add(ShareOnTwitterTapped())).called(1);
    });

    testWidgets(
        'does not add ShareOnTwitterTapped event '
        'when tapped but state is upload success', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
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

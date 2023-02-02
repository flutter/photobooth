// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

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

      verify(() => shareBloc.add(ShareOnFacebookTapped())).called(1);
    });

    testWidgets(
        'does not add ShareOnFacebook event '
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
      await tester.pumpApp(FacebookButton(), shareBloc: shareBloc);

      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();

      verifyNever(() => shareBloc.add(any()));
    });
  });
}

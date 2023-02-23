// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

class MockClipboard {
  Object get clipboardData => _clipboardData;
  Object _clipboardData = <String, dynamic>{
    'text': null,
  };

  Future<dynamic> handleMethodCall(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Clipboard.getData':
        return _clipboardData;
      case 'Clipboard.setData':
        _clipboardData = methodCall.arguments as Object;
        break;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const link = 'https://example.com/share/image.png';
  const suspendDuration = Duration(seconds: 5);

  group('ShareCopyableLink', () {
    MockClipboard? clipboard;

    setUp(() {
      clipboard = MockClipboard();
      SystemChannels.platform
          .setMockMethodCallHandler(clipboard?.handleMethodCall);
    });

    testWidgets(
        'tapping on copy button '
        'sets link in the clipboard', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      expect(clipboard?.clipboardData, equals({'text': link}));
    });

    testWidgets(
        'tapping on copy button '
        'sets copied to true', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      final state = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state.copied, isTrue);
    });

    testWidgets(
        'tapping on copy button '
        'sets copied to true '
        'and resets copied to false after suspendDuration time',
        (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      final state1 = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state1.copied, isTrue);
      await tester.pump(suspendDuration);
      final state2 = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state2.copied, isFalse);
    });

    testWidgets(
        'tapping on copy button '
        'hides copy button for suspendDuration time', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('shareCopyableLink_copyButton')), findsNothing);
      await tester.pump(suspendDuration);
      expect(find.byKey(Key('shareCopyableLink_copyButton')), findsOneWidget);
    });

    testWidgets(
        'tapping on copy button '
        'reveals copied button for suspendDuration time', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      expect(find.byKey(Key('shareCopyableLink_copiedButton')), findsNothing);
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('shareCopyableLink_copiedButton')), findsOneWidget);
      await tester.pump(suspendDuration);
      await tester.pump();
      expect(find.byKey(Key('shareCopyableLink_copiedButton')), findsNothing);
    });

    testWidgets(
        'tapping on copied button '
        'resets copied to false', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      final state1 = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state1.copied, isTrue);
      await tester.tap(find.byKey(Key('shareCopyableLink_copiedButton')));
      await tester.pumpAndSettle();
      final state2 = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state2.copied, isFalse);
    });

    testWidgets('timer is closed when widget is disposed', (tester) async {
      await tester.pumpApp(ShareCopyableLink(link: link));
      await tester.tap(find.byKey(Key('shareCopyableLink_copyButton')));
      await tester.pumpAndSettle();
      final state = tester.state<ShareCopyableLinkState>(
        find.byType(ShareCopyableLink),
      );
      expect(state.timer?.isActive, isTrue);
      await tester.pumpWidget(Container());
      expect(state.timer?.isActive, isFalse);
    });
  });
}

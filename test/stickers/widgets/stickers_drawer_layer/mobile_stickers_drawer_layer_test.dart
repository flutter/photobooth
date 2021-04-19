// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  group('MobileStickersDrawer', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: MobileStickersDrawer(
            onStickerSelected: (sticker) {},
          ),
        ),
      );
      expect(find.byType(MobileStickersDrawer), findsOneWidget);
    });
  });
}

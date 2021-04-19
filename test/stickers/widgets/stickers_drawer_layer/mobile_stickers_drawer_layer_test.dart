// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  setUpAll(() {
    registerFallbackValue<StickersEvent>(FakeStickersEvent());
    registerFallbackValue<StickersState>(FakeStickersState());
  });
  late StickersBloc stickersBloc;

  setUp(() {
    stickersBloc = MockStickersBloc();
  });

  group('MobileStickersDrawerLayer', () {
    testWidgets('renders', (tester) async {
      when(() => stickersBloc.state).thenReturn(StickersState());
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: MobileStickersDrawerLayer(
              stickersBloc: stickersBloc,
            ),
          ),
        ),
      );
      expect(find.byType(MobileStickersDrawerLayer), findsOneWidget);
    });

    testWidgets('verify it renders when changes', (tester) async {
      final state = StickersState();
      whenListen(
        stickersBloc,
        Stream.fromIterable([state]),
        initialState: state,
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: MobileStickersDrawerLayer(
              stickersBloc: stickersBloc,
            ),
          ),
        ),
      );
      expect(find.byType(MobileStickersDrawerLayer), findsOneWidget);
    });
  });

  group('MobileStickersDrawer', () {
    testWidgets('opens when state is active', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(2500, 2500);
      when(() => stickersBloc.state).thenReturn(
        StickersState(mode: StickersMode.active),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: MobileStickersDrawerLayer(
              stickersBloc: stickersBloc,
            ),
          ),
        ),
      );
    });

    testWidgets('adds StickerSelected when StickerChoice tapped',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(2500, 2500);
      final sticker = Assets.banana;
      when(() => stickersBloc.state).thenReturn(
        StickersState(mode: StickersMode.active, stickers: [sticker]),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: MobileStickersDrawerLayer(
              stickersBloc: stickersBloc,
            ),
          ),
        ),
      );
      final stickerChoice =
          tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
      stickerChoice.onPressed();
      verify(() => stickersBloc.add(StickerSelected(sticker: sticker)))
          .called(1);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('can be closed', (tester) async {
      when(() => stickersBloc.state)
          .thenReturn(StickersState(mode: StickersMode.active));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: MobileStickersDrawerLayer(
              stickersBloc: stickersBloc,
            ),
          ),
        ),
      );
      await tester
          .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.pumpAndSettle();
      verify(() => stickersBloc.add(StickersModeToggled())).called(1);
    });
  });
}

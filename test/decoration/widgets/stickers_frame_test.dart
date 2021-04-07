// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class FakeDecorationEvent extends Fake implements DecorationEvent {}

class FakeDecorationState extends Fake implements DecorationState {}

class MockDecorationBloc extends MockBloc<DecorationEvent, DecorationState>
    implements DecorationBloc {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  setUpAll(() {
    registerFallbackValue<DecorationEvent>(FakeDecorationEvent());
    registerFallbackValue<DecorationState>(FakeDecorationState());
  });

  group('StickersFrame', () {
    late DecorationBloc decorationBloc;

    setUp(() {
      decorationBloc = MockDecorationBloc();
      when(() => decorationBloc.state).thenReturn(DecorationState());
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets('does not render StickerCarousel when mode is inactive',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      expect(find.byType(StickersCarousel), findsNothing);
    });

    testWidgets('renders StickerCarousel when mode is active', (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(mode: DecorationMode.active),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      expect(find.byType(StickersCarousel), findsOneWidget);
    });

    testWidgets('adds DecorationModeToggled when OpenStickersButton tapped',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      await tester.ensureVisible(find.byType(OpenStickersButton));
      await tester.tap(find.byType(OpenStickersButton));
      verify(() => decorationBloc.add(DecorationModeToggled())).called(1);
    });

    testWidgets('does not display ResizableSticker when stickers is empty',
        (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(
          mode: DecorationMode.active,
          stickers: [],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      expect(find.byType(ResizableSticker), findsNothing);
    });

    testWidgets('displays ResizableSticker when stickers is populated',
        (tester) async {
      when(() => decorationBloc.state).thenReturn(
        DecorationState(
          mode: DecorationMode.active,
          stickers: [Assets.dash, Assets.dash],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      expect(find.byType(ResizableSticker), findsNWidgets(2));
    });

    testWidgets('adds DecorationStickerSelected when StickerChoice tapped',
        (tester) async {
      final sticker = Assets.dash;
      when(() => decorationBloc.state).thenReturn(
        DecorationState(
          mode: DecorationMode.active,
          stickers: [sticker],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(value: decorationBloc, child: StickersFrame()),
      );
      await tester.tap(find.byType(StickerChoice));
      verify(
        () => decorationBloc.add(DecorationStickerSelected(sticker: sticker)),
      ).called(1);
    });
  });
}

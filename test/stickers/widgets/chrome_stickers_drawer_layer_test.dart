// ignore_for_file: prefer_const_constructors
@TestOn('chrome')

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<StickersEvent>(FakeStickersEvent());
    registerFallbackValue<StickersState>(FakeStickersState());
  });

  group('StickersDrawerLayer', () {
    late StickersBloc stickersBloc;

    setUp(() {
      stickersBloc = MockStickersBloc();
      when(() => stickersBloc.state).thenReturn(StickersState());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersDrawerLayer(
            onStickerSelected: (sticker) {},
          ),
        ),
      );

      expect(find.byType(StickersDrawerLayer), findsOneWidget);
    });
  });
}

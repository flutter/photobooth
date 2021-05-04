// ignore_for_file: prefer_const_constructors
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../../helpers/helpers.dart';

class FakeStickersEvent extends Fake implements StickersEvent {}

class FakeStickersState extends Fake implements StickersState {}

class MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class FakeDragUpdate extends Fake implements DragUpdate {}

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  setUpAll(() {
    registerFallbackValue<StickersEvent>(FakeStickersEvent());
    registerFallbackValue<StickersState>(FakeStickersState());
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());
  });

  late StickersBloc stickersBloc;
  late PhotoboothBloc photoboothBloc;

  setUp(() {
    stickersBloc = MockStickersBloc();
    photoboothBloc = MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(
      image: image,
    ));
  });

  group('DesktopStickersDrawerLayer', () {
    testWidgets('renders', (tester) async {
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
            body: DesktopStickersDrawerLayer(),
          ),
        ),
      );
      expect(find.byType(DesktopStickersDrawerLayer), findsOneWidget);
    });
  });

  group('DesktopStickersDrawer', () {
    testWidgets('adds StickerSelected when StickerChoice tapped',
        (tester) async {
      tester.setDisplaySize(const Size(2500, 2500));
      final sticker = Assets.props.first;
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: sticker)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
            BlocProvider.value(value: photoboothBloc),
          ],
          child: Scaffold(
            body: DesktopStickersDrawer(),
          ),
        ),
      );
      final stickerChoice =
          tester.widgetList<StickerChoice>(find.byType(StickerChoice)).first;
      stickerChoice.onPressed();
      verify(() => photoboothBloc.add(PhotoStickerTapped(sticker: sticker)))
          .called(1);
    });

    testWidgets('can be closed', (tester) async {
      when(() => stickersBloc.state)
          .thenReturn(StickersState(isDrawerActive: true));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stickersBloc),
          ],
          child: Scaffold(
            body: DesktopStickersDrawer(),
          ),
        ),
      );
      await tester
          .ensureVisible(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.tap(find.byKey(Key('stickersDrawer_close_iconButton')));
      await tester.pumpAndSettle();
      verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
    });
  });
}

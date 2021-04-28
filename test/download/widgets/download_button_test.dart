import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/download/download.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockDownloadBloc extends MockBloc<DownloadEvent, DownloadState>
    implements DownloadBloc {}

class FakeDownloadEvent extends Fake implements DownloadEvent {}

class FakeDownloadState extends Fake implements DownloadState {}

void main() {
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  group('DownloadButton', () {
    late PhotoboothBloc photoboothBloc;
    late DownloadBloc downloadBloc;

    setUpAll(() {
      registerFallbackValue(FakePhotoboothEvent());
      registerFallbackValue(FakePhotoboothState());
      registerFallbackValue(FakeDownloadEvent());
      registerFallbackValue(FakeDownloadState());
    });

    setUp(() {
      photoboothBloc = MockPhotoboothBloc();
      downloadBloc = MockDownloadBloc();

      when(() => photoboothBloc.state).thenReturn(
        const PhotoboothState(image: image),
      );
      when(() => downloadBloc.state).thenReturn(const DownloadState.initial());
    });

    testWidgets('renders DownloadButtonView', (tester) async {
      await tester.pumpApp(const DownloadButton());
      expect(find.byType(DownloadButtonView), findsOneWidget);
    });

    testWidgets('renders loading indicator when downloading', (tester) async {
      when(() => downloadBloc.state).thenReturn(const DownloadState.loading());

      await tester.pumpApp(
        BlocProvider.value(
          value: downloadBloc,
          child: const DownloadButtonView(),
        ),
        photoboothBloc: photoboothBloc,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('tapping on download photo button adds DownloadTapped event',
        (tester) async {
      final downloadButtonFinder = find.byKey(
        const Key('downloadButton_download_outlinedButton'),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: downloadBloc,
          child: const DownloadButtonView(),
        ),
        photoboothBloc: photoboothBloc,
      );

      await tester.tap(downloadButtonFinder);

      verify(
        () => downloadBloc.add(const DownloadTapped(image: image, assets: [])),
      ).called(1);
    });
  });
}

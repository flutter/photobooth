import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:photos_repository/photos_repository.dart';

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class FakeShareEvent extends Fake implements ShareEvent {}

class FakeShareState extends Fake implements ShareState {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    PhotosRepository? photosRepository,
    PhotoboothBloc? photoboothBloc,
    ShareBloc? shareBloc,
  }) async {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());

    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());

    return mockNetworkImages(() async {
      return pumpWidget(
        RepositoryProvider.value(
          value: photosRepository ?? MockPhotosRepository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: photoboothBloc ?? MockPhotoboothBloc()),
              BlocProvider.value(value: shareBloc ?? MockShareBloc()),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: widget,
            ),
          ),
        ),
      );
    });
  }
}

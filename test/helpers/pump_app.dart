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

class MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class FakePhotoboothState extends Fake implements PhotoboothState {}

class MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class FakeShareEvent extends Fake implements ShareEvent {}

class FakeShareState extends Fake implements ShareState {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    PhotoboothBloc? photoboothBloc,
    ShareBloc? shareBloc,
  }) async {
    registerFallbackValue<PhotoboothEvent>(FakePhotoboothEvent());
    registerFallbackValue<PhotoboothState>(FakePhotoboothState());

    registerFallbackValue<ShareEvent>(FakeShareEvent());
    registerFallbackValue<ShareState>(FakeShareState());

    return pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: photoboothBloc ?? MockPhotoboothBloc()),
          BlocProvider.value(value: shareBloc ?? MockShareBloc()),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}

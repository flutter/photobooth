import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:share_photo_repository/share_photo_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.photosRepository,
    required this.sharePhotoRepository,
  }) : super(key: key);

  final PhotosRepository photosRepository;
  final SharePhotoRepository sharePhotoRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: photosRepository),
        RepositoryProvider.value(value: sharePhotoRepository),
      ],
      child: MaterialApp(
        title: 'I/O Photo Booth',
        theme: PhotoboothTheme.themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LandingPage(),
      ),
    );
  }
}

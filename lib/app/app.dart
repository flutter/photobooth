import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.photosRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photosRepository;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.authenticationRepository),
        RepositoryProvider.value(value: widget.photosRepository),
      ],
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: ResponsiveLayoutBuilder(
          small: (_, __) => _Home(theme: PhotoboothTheme.smallThemeData),
          large: (_, __) => _Home(theme: PhotoboothTheme.themeData),
        ),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({Key? key, required this.theme}) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I/O Photo Booth',
      theme: theme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LandingPage(),
    );
  }
}

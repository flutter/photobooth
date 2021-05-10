import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

import 'landing/loading_indicator_io.dart'
    if (dart.library.html) 'landing/loading_indicator_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    print(details.stack.toString());
  };

  final authenticationRepository = AuthenticationRepository(
    firebaseAuth: FirebaseAuth.instance,
  );
  final photosRepository = PhotosRepository(
    firebaseStorage: FirebaseStorage.instance,
    imageCompositor: ImageCompositor(),
  );

  unawaited(
    Firebase.initializeApp().then(
      (_) => authenticationRepository.signInAnonymously(),
    ),
  );

  runZonedGuarded(
    () => runApp(App(
      authenticationRepository: authenticationRepository,
      photosRepository: photosRepository,
    )),
    (error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
    },
  );

  SchedulerBinding.instance!.addPostFrameCallback(
    (_) => removeLoadingIndicator(),
  );
}

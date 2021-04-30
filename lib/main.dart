import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    print(details.stack.toString());
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  unawaited(Firebase.initializeApp()
      .then((_) => FirebaseAuth.instance.signInAnonymously()));

  final photosRepository = PhotosRepository(
    firebaseStorage: FirebaseStorage.instance,
  );

  unawaited(Assets.load());

  runZonedGuarded(
    () => runApp(App(photosRepository: photosRepository)),
    (error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}

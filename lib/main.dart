import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) {
      print(error.toString());
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}

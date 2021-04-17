import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';
import 'package:io_photobooth/assets/assets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    print(details.stack.toString());
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () => Assets.load().then((_) => runApp(const App())),
    (error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}

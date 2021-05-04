import 'package:flutter/services.dart';

void setupSoundpoolMethodChannel() {
  const MethodChannel('pl.ukaszapps/soundpool')
      .setMockMethodCallHandler((call) async {
    switch (call.method) {
      case 'initSoundpool':
        return 1;
      case 'load':
        return 1;
      case 'play':
        return 1;
      default:
    }
  });
}

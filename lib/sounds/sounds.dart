import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

abstract class Sounds {
  static late final int countDownBeep;
  static late final int countDownBeepOnCapture;

  static bool _initialized = false;
  static Soundpool pool = Soundpool(streamType: StreamType.notification);

  static Future<void> load() async {
    if (_initialized) return;
    final sounds = await Future.wait([
      _loadSound('assets/sounds/countdown_beep.mp3'),
      _loadSound('assets/sounds/countdown_beep_on_capture.mp3'),
    ]);

    countDownBeep = sounds[0];
    countDownBeepOnCapture = sounds[1];

    _initialized = true;
  }

  static Future<int> _loadSound(String path) async {
    final bytes = await rootBundle.load(path);
    return pool.load(bytes);
  }

  static Future<void> playShutterCountdownFinished() async {
    await pool.play(Sounds.countDownBeepOnCapture);
  }

  static Future<void> playShutterCountdown() async {
    for (var i = 0; i < 3; i++) {
      await pool.play(countDownBeep);
      //Multi audio not supported in web, we need to await
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}

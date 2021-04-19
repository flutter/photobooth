import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

abstract class Assets {
  // Characters
  static late final Asset android;
  static late final Asset dash;
  static late final Asset sparky;

  // Props
  static late final Asset banana;
  static late final Asset beret;
  static late final Asset birthdayCake;
  static late final Asset bowTie;
  static late final Asset catEyeGlasses;
  static late final Asset coffeeMug;
  static late final Asset dumbell;
  static late final Asset genericMug;
  static late final Asset genericGlasses;
  static late final Asset graphMug;
  static late final Asset guitar;
  static late final Asset headband;
  static late final Asset headphones;
  static late final Asset megaphone;
  static late final Asset ovalGlasses;
  static late final Asset partyHat;
  static late final Asset pencil;
  static late final Asset pizza;
  static late final Asset roundGlasses;
  static late final Asset roundGlasses1;
  static late final Asset soda;
  static late final Asset squareGlasses;
  static late final Asset star;
  static late final Asset sunglasses;

  static bool _initialized = false;

  static Future<void> load() async {
    if (_initialized) return;
    final assets = await Future.wait([
      //characters
      _loadAsset('assets/images/android.png'),
      _loadAsset('assets/images/dash.png'),
      _loadAsset('assets/images/sparky.png'),
      //props
      _loadAsset('assets/images/banana.png'),
      _loadAsset('assets/images/beret.png'),
      _loadAsset('assets/images/birthday_cake.png'),
      _loadAsset('assets/images/bow_tie.png'),
      _loadAsset('assets/images/cat_eye_glasses.png'),
      _loadAsset('assets/images/coffee_mug.png'),
      _loadAsset('assets/images/dumbell.png'),
      _loadAsset('assets/images/generic_mug.png'),
      _loadAsset('assets/images/generic_glasses.png'),
      _loadAsset('assets/images/graph_mug.png'),
      _loadAsset('assets/images/guitar.png'),
      _loadAsset('assets/images/headband.png'),
      _loadAsset('assets/images/headphones.png'),
      _loadAsset('assets/images/megaphone.png'),
      _loadAsset('assets/images/oval_glasses.png'),
      _loadAsset('assets/images/party_hat.png'),
      _loadAsset('assets/images/pencil.png'),
      _loadAsset('assets/images/pizza.png'),
      _loadAsset('assets/images/round_glasses.png'),
      _loadAsset('assets/images/round_glasses1.png'),
      _loadAsset('assets/images/soda.png'),
      _loadAsset('assets/images/square_glasses.png'),
      _loadAsset('assets/images/star.png'),
      _loadAsset('assets/images/sunglasses.png'),
    ]);
    android = assets[0];
    dash = assets[1];
    sparky = assets[2];

    banana = assets[3];
    beret = assets[4];
    birthdayCake = assets[5];
    bowTie = assets[6];
    catEyeGlasses = assets[7];
    coffeeMug = assets[8];
    dumbell = assets[9];
    genericMug = assets[10];
    genericGlasses = assets[11];
    graphMug = assets[12];
    guitar = assets[13];
    headband = assets[14];
    headphones = assets[15];
    megaphone = assets[16];
    ovalGlasses = assets[17];
    partyHat = assets[18];
    pencil = assets[19];
    pizza = assets[20];
    roundGlasses = assets[21];
    roundGlasses1 = assets[22];
    soda = assets[23];
    squareGlasses = assets[24];
    star = assets[25];
    sunglasses = assets[26];

    _initialized = true;
  }
}

Future<Asset> _loadAsset(String path) async {
  final data = await rootBundle.load(path);
  final bytes = Uint8List.view(data.buffer);
  final image = await decodeImageFromList(bytes);
  final imageBytes = await image.toByteData();

  return Asset(image: image, buffer: imageBytes!.buffer, bytes: bytes);
}

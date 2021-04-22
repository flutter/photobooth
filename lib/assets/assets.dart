import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

abstract class Assets {
  // Characters
  static late final Asset android;
  static late final Asset dash;
  static late final Asset sparky;
  static late final Asset dino;

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
      // Characters
      _loadAsset('android', 'assets/images/android.png'),
      _loadAsset('dash', 'assets/images/dash.png'),
      _loadAsset('sparky', 'assets/images/sparky.png'),
      _loadAsset('dino', 'assets/images/dino.png'),

      // Stickers
      _loadAsset('banana', 'assets/images/banana.png'),
      _loadAsset('beret', 'assets/images/beret.png'),
      _loadAsset('birthdayCake', 'assets/images/birthday_cake.png'),
      _loadAsset('bowTie', 'assets/images/bow_tie.png'),
      _loadAsset('catEyeGlasses', 'assets/images/cat_eye_glasses.png'),
      _loadAsset('coffeeMug', 'assets/images/coffee_mug.png'),
      _loadAsset('dumbell', 'assets/images/dumbell.png'),
      _loadAsset('genericMug', 'assets/images/generic_mug.png'),
      _loadAsset('genericGlasses', 'assets/images/generic_glasses.png'),
      _loadAsset('graphMug', 'assets/images/graph_mug.png'),
      _loadAsset('guitar', 'assets/images/guitar.png'),
      _loadAsset('headband', 'assets/images/headband.png'),
      _loadAsset('headphones', 'assets/images/headphones.png'),
      _loadAsset('megaphone', 'assets/images/megaphone.png'),
      _loadAsset('ovalGlasses', 'assets/images/oval_glasses.png'),
      _loadAsset('partyHat', 'assets/images/party_hat.png'),
      _loadAsset('pencil', 'assets/images/pencil.png'),
      _loadAsset('pizza', 'assets/images/pizza.png'),
      _loadAsset('roundGlasses', 'assets/images/round_glasses.png'),
      _loadAsset('roundGlasses1', 'assets/images/round_glasses1.png'),
      _loadAsset('soda', 'assets/images/soda.png'),
      _loadAsset('squareGlasses', 'assets/images/square_glasses.png'),
      _loadAsset('star', 'assets/images/star.png'),
      _loadAsset('sunglasses', 'assets/images/sunglasses.png'),
    ]);
    android = assets[0];
    dash = assets[1];
    sparky = assets[2];
    dino = assets[3];

    banana = assets[4];
    beret = assets[5];
    birthdayCake = assets[6];
    bowTie = assets[7];
    catEyeGlasses = assets[8];
    coffeeMug = assets[9];
    dumbell = assets[10];
    genericMug = assets[11];
    genericGlasses = assets[12];
    graphMug = assets[13];
    guitar = assets[14];
    headband = assets[15];
    headphones = assets[16];
    megaphone = assets[17];
    ovalGlasses = assets[18];
    partyHat = assets[19];
    pencil = assets[20];
    pizza = assets[21];
    roundGlasses = assets[22];
    roundGlasses1 = assets[23];
    soda = assets[24];
    squareGlasses = assets[25];
    star = assets[26];
    sunglasses = assets[27];

    _initialized = true;
  }
}

Future<Asset> _loadAsset(String name, String path) async {
  final data = await rootBundle.load(path);
  final bytes = Uint8List.view(data.buffer);
  final image = await decodeImageFromList(bytes);
  final imageBytes = await image.toByteData();

  return Asset(
    name: name,
    image: image,
    buffer: imageBytes!.buffer,
    bytes: bytes,
  );
}

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

enum Character { android, dash, sparky }
enum Sticker {
  banana,
  beret,
  birthdayCake,
  bowTie,
  catEyeGlasses,
  coffeeMug,
  dumbell,
  genericMug,
  genericGlasses,
  graphMug,
  guitar,
  headband,
  headphones,
  megaphone,
  ovalGlasses,
  partyHat,
  pencil,
  pizza,
  roundGlasses,
  roundGlasses1,
  soda,
  squareGlasses,
  star,
  sunglasses,
}

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
      // Characters
      _loadAsset(describeEnum(Character.android), 'assets/images/android.png'),
      _loadAsset(describeEnum(Character.dash), 'assets/images/dash.png'),
      _loadAsset(describeEnum(Character.sparky), 'assets/images/sparky.png'),

      // Stickers
      _loadAsset(describeEnum(Sticker.banana), 'assets/images/banana.png'),
      _loadAsset(describeEnum(Sticker.beret), 'assets/images/beret.png'),
      _loadAsset(describeEnum(Sticker.birthdayCake),
          'assets/images/birthday_cake.png'),
      _loadAsset(describeEnum(Sticker.bowTie), 'assets/images/bow_tie.png'),
      _loadAsset(describeEnum(Sticker.catEyeGlasses),
          'assets/images/cat_eye_glasses.png'),
      _loadAsset(
          describeEnum(Sticker.coffeeMug), 'assets/images/coffee_mug.png'),
      _loadAsset(describeEnum(Sticker.dumbell), 'assets/images/dumbell.png'),
      _loadAsset(
          describeEnum(Sticker.genericMug), 'assets/images/generic_mug.png'),
      _loadAsset(describeEnum(Sticker.genericGlasses),
          'assets/images/generic_glasses.png'),
      _loadAsset(describeEnum(Sticker.graphMug), 'assets/images/graph_mug.png'),
      _loadAsset(describeEnum(Sticker.guitar), 'assets/images/guitar.png'),
      _loadAsset(describeEnum(Sticker.headband), 'assets/images/headband.png'),
      _loadAsset(
          describeEnum(Sticker.headphones), 'assets/images/headphones.png'),
      _loadAsset(
          describeEnum(Sticker.megaphone), 'assets/images/megaphone.png'),
      _loadAsset(
          describeEnum(Sticker.ovalGlasses), 'assets/images/oval_glasses.png'),
      _loadAsset(describeEnum(Sticker.partyHat), 'assets/images/party_hat.png'),
      _loadAsset(describeEnum(Sticker.pencil), 'assets/images/pencil.png'),
      _loadAsset(describeEnum(Sticker.pizza), 'assets/images/pizza.png'),
      _loadAsset(describeEnum(Sticker.roundGlasses),
          'assets/images/round_glasses.png'),
      _loadAsset(describeEnum(Sticker.roundGlasses1),
          'assets/images/round_glasses1.png'),
      _loadAsset(describeEnum(Sticker.soda), 'assets/images/soda.png'),
      _loadAsset(describeEnum(Sticker.squareGlasses),
          'assets/images/square_glasses.png'),
      _loadAsset(describeEnum(Sticker.star), 'assets/images/star.png'),
      _loadAsset(
          describeEnum(Sticker.sunglasses), 'assets/images/sunglasses.png'),
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

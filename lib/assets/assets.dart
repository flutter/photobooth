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
  static late final Set<Asset> props;
  static late final List<Asset> googleProps;
  static late final List<Asset> hatsProps;
  static late final List<Asset> eyewearProps;
  static late final List<Asset> foodProps;
  static late final List<Asset> shapesProps;
  static bool _initialized = false;

  static Future<void> load() async {
    if (_initialized) return;
    final charactersAssets = [
      _loadAsset('android', 'assets/images/android.png'),
      _loadAsset('dash', 'assets/images/dash.png'),
      _loadAsset('sparky', 'assets/images/sparky.png'),
      _loadAsset('dino', 'assets/images/dino.png'),
    ];

    final googleAssets = [
      _loadAsset('google01', 'assets/props/google/01_google_v1.png'),
      _loadAsset('google02', 'assets/props/google/02_google_v1.png'),
      _loadAsset('google03', 'assets/props/google/03_google_V1.png'),
      _loadAsset('google04', 'assets/props/google/04_google_v1.png'),
      _loadAsset('google05', 'assets/props/google/05_google_v1.png'),
      _loadAsset('google06', 'assets/props/google/06_google_v1.png'),
      _loadAsset('google07', 'assets/props/google/07_google_v1.png'),
      _loadAsset('google08', 'assets/props/google/08_google_v1.png'),
      _loadAsset('google09', 'assets/props/google/09_google_v1.png'),
      _loadAsset('google10', 'assets/props/google/10_google_v1.png'),
      _loadAsset('google11', 'assets/props/google/11_google_v1.png'),
      _loadAsset('google12', 'assets/props/google/12_google_v1.png'),
      _loadAsset('google13', 'assets/props/google/13_google_v1.png'),
      _loadAsset('google14', 'assets/props/google/14_google_v1.png'),
      _loadAsset('google15', 'assets/props/google/15_google_v1.png'),
      _loadAsset('google16', 'assets/props/google/16_google_v1.png'),
      _loadAsset('google17', 'assets/props/google/17_google_v1.png'),
      _loadAsset('google18', 'assets/props/google/18_google_v1.png'),
      _loadAsset('google19', 'assets/props/google/19_google_v1.png'),
      _loadAsset('google20', 'assets/props/google/20_google_v1.png'),
      _loadAsset('google21', 'assets/props/google/21_google_v1.png'),
      _loadAsset('google22', 'assets/props/google/22_google_v1.png'),
      _loadAsset('google23', 'assets/props/google/23_google_v1.png'),
      _loadAsset('google24', 'assets/props/google/24_google_v1.png'),
      _loadAsset('google25', 'assets/props/google/25_google_v1.png'),
      _loadAsset('google26', 'assets/props/google/26_google_v1.png'),
      _loadAsset('google27', 'assets/props/google/27_google_v1.png'),
      _loadAsset('google28', 'assets/props/google/28_google_v1.png'),
      _loadAsset('google29', 'assets/props/google/29_google_v1.png'),
      _loadAsset('google30', 'assets/props/google/30_google_v1.png'),
      _loadAsset('google31', 'assets/props/google/31_google_v1.png'),
      _loadAsset('google32', 'assets/props/google/32_google_v1.png'),
      _loadAsset('google33', 'assets/props/google/33_google_v1.png'),
      _loadAsset('google34', 'assets/props/google/34_google_v1.png'),
      _loadAsset('google35', 'assets/props/google/35_google_v1.png'),
    ];

    final hatsAssets = [
      _loadAsset('hats01', 'assets/props/hats/01_hats_v1.png'),
      _loadAsset('hats02', 'assets/props/hats/02_hats_v1.png'),
      _loadAsset('hats03', 'assets/props/hats/03_hats_v1.png'),
      _loadAsset('hats04', 'assets/props/hats/04_hats_v1.png'),
      _loadAsset('hats05', 'assets/props/hats/05_hats_v1.png'),
      _loadAsset('hats06', 'assets/props/hats/06_hats_v1.png'),
      _loadAsset('hats07', 'assets/props/hats/07_hats_v1.png'),
      _loadAsset('hats08', 'assets/props/hats/08_hats_v1.png'),
      _loadAsset('hats09', 'assets/props/hats/09_hats_v1.png'),
      _loadAsset('hats10', 'assets/props/hats/10_hats_v1.png'),
      _loadAsset('hats11', 'assets/props/hats/11_hats_v1.png'),
      _loadAsset('hats12', 'assets/props/hats/12_hats_v1.png'),
      _loadAsset('hats13', 'assets/props/hats/13_hats_v1.png'),
      _loadAsset('hats14', 'assets/props/hats/14_hats_v1.png'),
      _loadAsset('hats15', 'assets/props/hats/15_hats_v1.png'),
      _loadAsset('hats16', 'assets/props/hats/16_hats_v1.png'),
      _loadAsset('hats17', 'assets/props/hats/17_hats_v1.png'),
      _loadAsset('hats18', 'assets/props/hats/18_hats_v1.png'),
      _loadAsset('hats19', 'assets/props/hats/19_hats_v1.png'),
      _loadAsset('hats20', 'assets/props/hats/20_hats_v1.png'),
      _loadAsset('hats21', 'assets/props/hats/21_hats_v1.png'),
      _loadAsset('hats22', 'assets/props/hats/22_hats_v1.png'),
      _loadAsset('hats23', 'assets/props/hats/23_hats_v1.png'),
      _loadAsset('hats24', 'assets/props/hats/24_hats_v1.png'),
      _loadAsset('hats25', 'assets/props/hats/25_hats_v1.png'),
      _loadAsset('hats26', 'assets/props/hats/26_hats_v1.png'),
    ];

    final eyeWearAssets = [
      _loadAsset('eyewear01', 'assets/props/eyewear/01_eyewear_v1.png'),
      _loadAsset('eyewear02', 'assets/props/eyewear/02_eyewear_v1.png'),
      _loadAsset('eyewear03', 'assets/props/eyewear/03_eyewear_v1.png'),
      _loadAsset('eyewear04', 'assets/props/eyewear/04_eyewear_v1.png'),
      _loadAsset('eyewear05', 'assets/props/eyewear/05_eyewear_v1.png'),
      _loadAsset('eyewear06', 'assets/props/eyewear/06_eyewear_v1.png'),
      _loadAsset('eyewear07', 'assets/props/eyewear/07_eyewear_v1.png'),
      _loadAsset('eyewear08', 'assets/props/eyewear/08_eyewear_v1.png'),
      _loadAsset('eyewear09', 'assets/props/eyewear/09_eyewear_v1.png'),
      _loadAsset('eyewear10', 'assets/props/eyewear/10_eyewear_v1.png'),
      _loadAsset('eyewear11', 'assets/props/eyewear/11_eyewear_v1.png'),
      _loadAsset('eyewear12', 'assets/props/eyewear/12_eyewear_v1.png'),
      _loadAsset('eyewear13', 'assets/props/eyewear/13_eyewear_v1.png'),
      _loadAsset('eyewear14', 'assets/props/eyewear/14_eyewear_v1.png'),
      _loadAsset('eyewear15', 'assets/props/eyewear/15_eyewear_v1.png'),
      _loadAsset('eyewear16', 'assets/props/eyewear/16_eyewear_v1.png'),
    ];

    final foodAssets = [
      _loadAsset('food01', 'assets/props/food/01_food_v1.png'),
      _loadAsset('food02', 'assets/props/food/02_food_v1.png'),
      _loadAsset('food03', 'assets/props/food/03_food_v1.png'),
      _loadAsset('food04', 'assets/props/food/04_food_v1.png'),
      _loadAsset('food05', 'assets/props/food/05_food_v1.png'),
      _loadAsset('food06', 'assets/props/food/06_food_v1.png'),
      _loadAsset('food07', 'assets/props/food/07_food_v1.png'),
      _loadAsset('food08', 'assets/props/food/08_food_v1.png'),
      _loadAsset('food09', 'assets/props/food/09_food_v1.png'),
      _loadAsset('food10', 'assets/props/food/10_food_v1.png'),
      _loadAsset('food11', 'assets/props/food/11_food_v1.png'),
      _loadAsset('food12', 'assets/props/food/12_food_v1.png'),
      _loadAsset('food13', 'assets/props/food/13_food_v1.png'),
      _loadAsset('food14', 'assets/props/food/14_food_v1.png'),
      _loadAsset('food15', 'assets/props/food/15_food_v1.png'),
      _loadAsset('food16', 'assets/props/food/16_food_v1.png'),
      _loadAsset('food17', 'assets/props/food/17_food_v1.png'),
      _loadAsset('food18', 'assets/props/food/18_food_v1.png'),
      _loadAsset('food19', 'assets/props/food/19_food_v1.png'),
      _loadAsset('food20', 'assets/props/food/20_food_v1.png'),
      _loadAsset('food21', 'assets/props/food/21_food_v1.png'),
      _loadAsset('food22', 'assets/props/food/22_food_v1.png'),
      _loadAsset('food23', 'assets/props/food/23_food_v1.png'),
      _loadAsset('food24', 'assets/props/food/24_food_v1.png'),
      _loadAsset('food25', 'assets/props/food/25_food_v1.png'),
    ];

    final shapesAssets = [
      _loadAsset('shapes01', 'assets/props/shapes/01_shapes_v1.png'),
      _loadAsset('shapes02', 'assets/props/shapes/02_shapes_v1.png'),
      _loadAsset('shapes03', 'assets/props/shapes/03_shapes_v1.png'),
      _loadAsset('shapes04', 'assets/props/shapes/04_shapes_v1.png'),
      _loadAsset('shapes05', 'assets/props/shapes/05_shapes_v1.png'),
      _loadAsset('shapes06', 'assets/props/shapes/06_shapes_v1.png'),
      _loadAsset('shapes07', 'assets/props/shapes/07_shapes_v1.png'),
      _loadAsset('shapes08', 'assets/props/shapes/08_shapes_v1.png'),
      _loadAsset('shapes09', 'assets/props/shapes/09_shapes_v1.png'),
      _loadAsset('shapes10', 'assets/props/shapes/10_shapes_v1.png'),
      _loadAsset('shapes11', 'assets/props/shapes/11_shapes_v1.png'),
      _loadAsset('shapes12', 'assets/props/shapes/12_shapes_v1.png'),
      _loadAsset('shapes13', 'assets/props/shapes/13_shapes_v1.png'),
      _loadAsset('shapes14', 'assets/props/shapes/14_shapes_v1.png'),
      _loadAsset('shapes15', 'assets/props/shapes/15_shapes_v1.png'),
      _loadAsset('shapes16', 'assets/props/shapes/16_shapes_v1.png'),
      _loadAsset('shapes17', 'assets/props/shapes/17_shapes_v1.png'),
      _loadAsset('shapes18', 'assets/props/shapes/18_shapes_v1.png'),
      _loadAsset('shapes19', 'assets/props/shapes/19_shapes_v1.png'),
      _loadAsset('shapes20', 'assets/props/shapes/20_shapes_v1.png'),
      _loadAsset('shapes21', 'assets/props/shapes/21_shapes_v1.png'),
      _loadAsset('shapes22', 'assets/props/shapes/22_shapes_v1.png'),
      _loadAsset('shapes23', 'assets/props/shapes/23_shapes_v1.png'),
      _loadAsset('shapes24', 'assets/props/shapes/24_shapes_v1.png'),
      _loadAsset('shapes25', 'assets/props/shapes/25_shapes_v1.png'),
    ];

    final assets = await Future.wait([
      // Characters
      ...charactersAssets,

      // Props
      ...googleAssets,
      ...hatsAssets,
      ...eyeWearAssets,
      ...foodAssets,
      ...shapesAssets,
    ]);

    android = await charactersAssets[0];
    dash = await charactersAssets[1];
    sparky = await charactersAssets[2];
    dino = await charactersAssets[3];

    googleProps = await Future.wait(googleAssets);
    hatsProps = await Future.wait(hatsAssets);
    eyewearProps = await Future.wait(eyeWearAssets);
    foodProps = await Future.wait(foodAssets);
    shapesProps = await Future.wait(shapesAssets);

    props = assets.sublist(charactersAssets.length).toSet();

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
    path: path,
  );
}

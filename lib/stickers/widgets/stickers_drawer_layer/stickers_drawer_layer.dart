import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

final _stickers = [
  Assets.banana,
  Assets.beret,
  Assets.birthdayCake,
  Assets.bowTie,
  Assets.catEyeGlasses,
  Assets.coffeeMug,
  Assets.dumbell,
  Assets.genericMug,
  Assets.genericGlasses,
  Assets.graphMug,
  Assets.guitar,
  Assets.headband,
  Assets.headphones,
  Assets.megaphone,
  Assets.ovalGlasses,
  Assets.partyHat,
  Assets.pencil,
  Assets.pizza,
  Assets.roundGlasses,
  Assets.roundGlasses1,
  Assets.soda,
  Assets.squareGlasses,
  Assets.star,
  Assets.sunglasses,
];

class StickersDrawerLayer extends StatelessWidget {
  const StickersDrawerLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(
      mobile: const SizedBox(),
      desktop: const DesktopStickersDrawerLayer(),
    );
  }
}

class StickersGrid extends StatelessWidget {
  const StickersGrid({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final ValueSetter<Asset> onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      itemCount: _stickers.length,
      itemBuilder: (context, index) => StickerChoice(
        asset: _stickers[index],
        onPressed: () {
          onStickerSelected.call(_stickers[index]);
        },
      ),
    );
  }
}

class StickerChoice extends StatelessWidget {
  const StickerChoice({
    Key? key,
    required this.asset,
    required this.onPressed,
  }) : super(key: key);

  final Asset asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PhotoboothColors.transparent,
      child: Ink.image(
        image: MemoryImage(asset.bytes),
        child: InkWell(onTap: onPressed),
      ),
    );
  }
}

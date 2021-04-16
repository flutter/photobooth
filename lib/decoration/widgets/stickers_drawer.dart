import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class StickersDrawer extends StatelessWidget {
  const StickersDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stickers = [
      Assets.banana,
      Assets.barette,
      Assets.birthdayCake,
      Assets.bowtie,
      Assets.cateyeGlasses,
      Assets.coffeeMug,
      Assets.dumbell,
      Assets.genericMug,
      Assets.genGlasses,
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
    final width = MediaQuery.of(context).size.width;
    final l10n = context.l10n;
    return Container(
      width: width * 0.35,
      color: PhotoboothColors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    l10n.stickersDrawerTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 30),
                  ),
                ),
                IconButton(
                  key: const Key('stickersDrawer_close_iconButton'),
                  onPressed: () => context
                      .read<DecorationBloc>()
                      .add(const DecorationModeToggled()),
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Flexible(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 15,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: stickers.length,
              itemBuilder: (context, index) => StickerChoice(
                asset: stickers[index],
                onPressed: () => context.read<DecorationBloc>().add(
                      DecorationStickerSelected(
                        sticker: stickers[index],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
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
    return GestureDetector(
      onTap: onPressed,
      child: Image.memory(
        asset.bytes,
        height: asset.image.height.toDouble(),
        width: asset.image.width.toDouble(),
      ),
    );
  }
}

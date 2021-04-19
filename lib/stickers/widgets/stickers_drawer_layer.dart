import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';

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
  const StickersDrawerLayer({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);
  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StickersBloc, StickersState>(
      buildWhen: (previous, current) =>
          !isMobile && previous.mode != current.mode,
      builder: (context, state) {
        return state.mode.isActive
            ? Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: WebStickersDrawer(
                  onStickerSelected: onStickerSelected,
                ),
              )
            : const SizedBox();
      },
      listenWhen: (previous, current) =>
          isMobile && current.mode.isActive && current.mode != previous.mode,
      listener: (context, state) async {
        await showModalBottomSheet(
          context: context,
          backgroundColor: PhotoboothColors.transparent,
          isScrollControlled: true,
          builder: (context) => MobileStickersDrawer(
            onStickerSelected: onStickerSelected,
          ),
        ).whenComplete(() =>
            context.read<StickersBloc>().add(const StickersModeToggled()));
      },
    );
  }
}

class MobileStickersDrawer extends StatelessWidget {
  const MobileStickersDrawer({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.95,
      decoration: const BoxDecoration(
        color: PhotoboothColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, right: 22),
              child: IconButton(
                key: const Key('stickersDrawer_close_iconButton'),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          Text(
            l10n.stickersDrawerTitle,
            style:
                Theme.of(context).textTheme.headline3!.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 15),
          Flexible(
            child: StickersGrid(
              onStickerSelected: onStickerSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class WebStickersDrawer extends StatelessWidget {
  const WebStickersDrawer({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
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
                      .read<StickersBloc>()
                      .add(const StickersModeToggled()),
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Flexible(
            child: StickersGrid(
              onStickerSelected: onStickerSelected,
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class StickersGrid extends StatelessWidget {
  const StickersGrid({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;

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
      child: Image.memory(asset.bytes),
    );
  }
}

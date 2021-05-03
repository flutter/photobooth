import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
      itemCount: Assets.props.length,
      itemBuilder: (context, index) => StickerChoice(
        asset: Assets.props.elementAt(index),
        onPressed: () {
          onStickerSelected.call(Assets.props.elementAt(index));
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

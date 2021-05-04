import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersTabs extends StatelessWidget {
  const StickersTabs({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final ValueSetter<Asset> onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              StickersTab(
                key: Key('stickersTabs_googleTab'),
                assetPath: 'assets/icons/google_icon.png',
                width: 17.64,
                height: 18,
              ),
              StickersTab(
                key: Key('stickersTabs_hatsTab'),
                assetPath: 'assets/icons/hats_icon.png',
                width: 30,
                height: 13.85,
              ),
              StickersTab(
                key: Key('stickersTabs_eyewearTab'),
                assetPath: 'assets/icons/eyewear_icon.png',
                width: 30,
                height: 11.24,
              ),
              StickersTab(
                key: Key('stickersTabs_foodTab'),
                assetPath: 'assets/icons/food_icon.png',
                width: 22,
                height: 21.99,
              ),
              StickersTab(
                key: Key('stickersTabs_shapesTab'),
                assetPath: 'assets/icons/shapes_icon.png',
                width: 21,
                height: 21,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: TabBarView(
              children: [
                StickersTabBarView(
                  key: const Key('stickersTabs_googleTabBarView'),
                  stickers: Assets.googleProps,
                  onStickerSelected: onStickerSelected,
                ),
                StickersTabBarView(
                  key: const Key('stickersTabs_hatsTabBarView'),
                  stickers: Assets.hatsProps,
                  onStickerSelected: onStickerSelected,
                ),
                StickersTabBarView(
                  key: const Key('stickersTabs_eyewearTabBarView'),
                  stickers: Assets.eyewearProps,
                  onStickerSelected: onStickerSelected,
                ),
                StickersTabBarView(
                  key: const Key('stickersTabs_foodTabBarView'),
                  stickers: Assets.foodProps,
                  onStickerSelected: onStickerSelected,
                ),
                StickersTabBarView(
                  key: const Key('stickersTabs_shapesTabBarView'),
                  stickers: Assets.shapesProps,
                  onStickerSelected: onStickerSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class StickersTab extends StatelessWidget {
  const StickersTab({
    Key? key,
    required this.assetPath,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String assetPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 24),
      icon: Image.asset(assetPath, width: width, height: height),
    );
  }
}

@visibleForTesting
class StickersTabBarView extends StatelessWidget {
  const StickersTabBarView({
    Key? key,
    required this.stickers,
    required this.onStickerSelected,
  }) : super(key: key);

  final List<Asset> stickers;
  final ValueSetter<Asset> onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 65),
      itemCount: stickers.length,
      itemBuilder: (context, index) => StickerChoice(
        asset: stickers[index],
        onPressed: () => onStickerSelected.call(stickers[index]),
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
    return Material(
      color: PhotoboothColors.transparent,
      child: Ink.image(
        image: MemoryImage(asset.bytes),
        child: InkWell(onTap: onPressed),
      ),
    );
  }
}

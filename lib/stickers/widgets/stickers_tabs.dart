import 'package:flutter/material.dart';
import 'package:io_photobooth/assets.g.dart';
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
              ),
              StickersTab(
                key: Key('stickersTabs_hatsTab'),
                assetPath: 'assets/icons/hats_icon.png',
              ),
              StickersTab(
                key: Key('stickersTabs_eyewearTab'),
                assetPath: 'assets/icons/eyewear_icon.png',
              ),
              StickersTab(
                key: Key('stickersTabs_foodTab'),
                assetPath: 'assets/icons/food_icon.png',
              ),
              StickersTab(
                key: Key('stickersTabs_shapesTab'),
                assetPath: 'assets/icons/shapes_icon.png',
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
                  stickers: Assets.hatProps,
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
                  stickers: Assets.shapeProps,
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
  }) : super(key: key);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 24),
      icon: Image.asset(
        assetPath,
        width: 30,
        height: 30,
        color: IconTheme.of(context).color,
      ),
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

  final Set<Asset> stickers;
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
      itemBuilder: (context, index) {
        final sticker = stickers.elementAt(index);
        return StickerChoice(
          asset: sticker,
          onPressed: () => onStickerSelected.call(sticker),
        );
      },
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
        image: AssetImage(asset.path),
        child: InkWell(onTap: onPressed),
      ),
    );
  }
}

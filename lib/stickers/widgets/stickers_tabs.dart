import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersTabs extends StatefulWidget {
  const StickersTabs({
    Key? key,
    required this.onStickerSelected,
    required this.tabSelected,
  }) : super(key: key);

  final ValueSetter<Asset> onStickerSelected;
  final int tabSelected;

  @override
  State<StickersTabs> createState() => _StickersTabsState();
}

class _StickersTabsState extends State<StickersTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    print(widget.tabSelected);
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.tabSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          onTap: (value) => context
              .read<StickersBloc>()
              .add(StickersDrawerTabSelected(tabSelected: value)),
          controller: _tabController,
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
            controller: _tabController,
            children: [
              StickersTabBarView(
                key: const Key('stickersTabs_googleTabBarView'),
                stickers: Assets.googleProps,
                onStickerSelected: widget.onStickerSelected,
              ),
              StickersTabBarView(
                key: const Key('stickersTabs_hatsTabBarView'),
                stickers: Assets.hatProps,
                onStickerSelected: widget.onStickerSelected,
              ),
              StickersTabBarView(
                key: const Key('stickersTabs_eyewearTabBarView'),
                stickers: Assets.eyewearProps,
                onStickerSelected: widget.onStickerSelected,
              ),
              StickersTabBarView(
                key: const Key('stickersTabs_foodTabBarView'),
                stickers: Assets.foodProps,
                onStickerSelected: widget.onStickerSelected,
              ),
              StickersTabBarView(
                key: const Key('stickersTabs_shapesTabBarView'),
                stickers: Assets.shapeProps,
                onStickerSelected: widget.onStickerSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class StickersTab extends StatefulWidget {
  const StickersTab({
    Key? key,
    required this.assetPath,
  }) : super(key: key);

  final String assetPath;

  @override
  _StickersTabState createState() => _StickersTabState();
}

class _StickersTabState extends State<StickersTab>
    with AutomaticKeepAliveClientMixin<StickersTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 24),
      icon: Image.asset(
        widget.assetPath,
        width: 30,
        height: 30,
        color: IconTheme.of(context).color,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    return Image.asset(
      asset.path,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        return AppAnimatedCrossFade(
          firstChild: SizedBox.fromSize(
            size: const Size(20, 20),
            child: const AppCircularProgressIndicator(strokeWidth: 2),
          ),
          secondChild: InkWell(
            onTap: onPressed,
            child: child,
          ),
          crossFadeState: frame == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        );
      },
    );
  }
}

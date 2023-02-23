import 'package:flutter/material.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersTabs extends StatefulWidget {
  const StickersTabs({
    required this.onStickerSelected,
    required this.onTabChanged,
    this.initialIndex = 0,
    super.key,
  });

  final ValueSetter<Asset> onStickerSelected;
  final ValueSetter<int> onTabChanged;
  final int initialIndex;

  @override
  State<StickersTabs> createState() => _StickersTabsState();
}

class _StickersTabsState extends State<StickersTabs>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      // False when swipe
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          onTap: widget.onTabChanged,
          controller: _tabController,
          tabs: const [
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
    required this.assetPath,
    super.key,
  });

  final String assetPath;

  @override
  State<StickersTab> createState() => _StickersTabState();
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
    required this.stickers,
    required this.onStickerSelected,
    super.key,
  });

  final Set<Asset> stickers;
  final ValueSetter<Asset> onStickerSelected;

  static const _smallGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 100,
    mainAxisSpacing: 48,
    crossAxisSpacing: 24,
  );

  static const _defaultGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150,
    mainAxisSpacing: 64,
    crossAxisSpacing: 42,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gridDelegate = size.width < PhotoboothBreakpoints.small
        ? _smallGridDelegate
        : _defaultGridDelegate;
    return GridView.builder(
      key: PageStorageKey<String>('$key'),
      gridDelegate: gridDelegate,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      itemCount: stickers.length,
      itemBuilder: (context, index) {
        final sticker = stickers.elementAt(index);
        return StickerChoice(
          asset: sticker,
          onPressed: () => onStickerSelected(sticker),
        );
      },
    );
  }
}

@visibleForTesting
class StickerChoice extends StatelessWidget {
  const StickerChoice({
    required this.asset,
    required this.onPressed,
    super.key,
  });

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

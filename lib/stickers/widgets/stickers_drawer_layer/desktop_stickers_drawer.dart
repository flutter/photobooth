import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DesktopStickersDrawer extends StatelessWidget {
  const DesktopStickersDrawer({
    Key? key,
    required this.initialIndex,
    required this.onStickerSelected,
    required this.onTabChanged,
    required this.onCloseTapped,
    required this.bucket,
  }) : super(key: key);

  final int initialIndex;
  final ValueSetter<Asset> onStickerSelected;
  final ValueSetter<int> onTabChanged;
  final VoidCallback onCloseTapped;
  final PageStorageBucket bucket;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final l10n = context.l10n;
    return PageStorage(
      bucket: bucket,
      child: Container(
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
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  IconButton(
                    key: const Key('stickersDrawer_close_iconButton'),
                    onPressed: onCloseTapped,
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: StickersTabs(
                initialIndex: initialIndex,
                onTabChanged: onTabChanged,
                onStickerSelected: onStickerSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

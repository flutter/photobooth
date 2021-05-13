import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MobileStickersDrawer extends StatelessWidget {
  const MobileStickersDrawer({
    Key? key,
    required this.onStickerSelected,
    required this.bucket,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;
  final PageStorageBucket bucket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;
    return PageStorage(
      bucket: bucket,
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        height: screenHeight < PhotoboothBreakpoints.small
            ? screenHeight
            : screenHeight * 0.75,
        decoration: const BoxDecoration(
          color: PhotoboothColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      l10n.stickersDrawerTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Flexible(
                  child: StickersTabs(
                    tabSelected: context.read<StickersBloc>().state.tabSelected,
                    onStickerSelected: (sticker) {
                      onStickerSelected(sticker);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 24,
              top: 24,
              child: IconButton(
                key: const Key('stickersDrawer_close_iconButton'),
                icon: const Icon(
                  Icons.clear,
                  color: PhotoboothColors.black54,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

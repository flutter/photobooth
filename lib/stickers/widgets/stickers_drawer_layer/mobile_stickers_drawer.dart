import 'package:flutter/material.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

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
      width: size.width,
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

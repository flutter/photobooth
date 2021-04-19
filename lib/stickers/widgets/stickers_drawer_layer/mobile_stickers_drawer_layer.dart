import 'package:flutter/material.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class MobileStickersDrawerLayer extends StatelessWidget {
  const MobileStickersDrawerLayer({Key? key, required this.stickersBloc})
      : super(key: key);

  final StickersBloc stickersBloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StickersBloc, StickersState>(
      listenWhen: (previous, current) =>
          current.mode.isActive && current.mode != previous.mode,
      listener: (context, state) async {
        await showModalBottomSheet(
          context: context,
          backgroundColor: PhotoboothColors.transparent,
          isScrollControlled: true,
          builder: (_) => MobileStickersDrawer(
            onStickerSelected: (sticker) =>
                stickersBloc.add(StickerSelected(sticker: sticker)),
          ),
        ).whenComplete(() => stickersBloc.add(const StickersModeToggled()));
      },
      child: const SizedBox(),
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

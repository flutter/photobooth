import 'package:flutter/material.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class DesktopStickersDrawerLayer extends StatelessWidget {
  const DesktopStickersDrawerLayer({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StickersBloc, StickersState>(
      buildWhen: (previous, current) => previous.mode != current.mode,
      builder: (context, state) {
        return state.mode.isActive
            ? Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: DesktopStickersDrawer(
                  onStickerSelected: onStickerSelected,
                ),
              )
            : const SizedBox();
      },
    );
  }
}

class DesktopStickersDrawer extends StatelessWidget {
  const DesktopStickersDrawer({
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
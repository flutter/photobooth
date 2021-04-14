import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/bloc/decoration_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class StickersDrawer extends StatelessWidget {
  const StickersDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stickers = [Assets.dash];
    final width = MediaQuery.of(context).size.width;
    final l10n = context.l10n;
    return Container(
      width: width * 0.3,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 46, right: 46, top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.stickersDrawerTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 30),
              ),
              IconButton(
                  onPressed: () => context
                      .read<DecorationBloc>()
                      .add(const DecorationModeToggled()),
                  icon: const Icon(Icons.clear)),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: stickers.length,
              itemBuilder: (context, index) => StickerChoice(
                asset: stickers[index],
                onPressed: () => context.read<DecorationBloc>().add(
                      DecorationStickerSelected(sticker: stickers[index]),
                    ),
              ),
            ),
          ),
        ],
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
    return GestureDetector(
      child: Image.memory(
        asset.bytes,
        height: asset.image.height.toDouble(),
        width: asset.image.width.toDouble(),
      ),
      onTap: onPressed,
    );
  }
}

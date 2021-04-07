import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';

class StickersFrame extends StatelessWidget {
  const StickersFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DecorationBloc>().state;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          right: 15,
          top: 15,
          child: OpenStickersButton(
            onPressed: () {
              context.read<DecorationBloc>().add(const DecorationModeToggled());
            },
          ),
        ),
        if (state.mode.isActive)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickersCarousel(
              onStickerSelected: (sticker) {
                context
                    .read<DecorationBloc>()
                    .add(DecorationStickerSelected(sticker: sticker));
              },
            ),
          ),
        for (final sticker in state.stickers)
          ResizableSticker(sticker: sticker),
      ],
    );
  }
}

class OpenStickersButton extends StatelessWidget {
  const OpenStickersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/icons/stickers_icon.png',
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}

class StickersCarousel extends StatelessWidget {
  const StickersCarousel({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final ValueSetter<Asset> onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(15),
      color: Colors.grey.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StickerChoice(
            asset: Assets.dash,
            onStickerSelected: onStickerSelected,
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
    required this.onStickerSelected,
  }) : super(key: key);

  final Asset asset;
  final ValueSetter<Asset> onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.memory(
        asset.bytes,
        height: asset.image.height.toDouble(),
        width: asset.image.width.toDouble(),
      ),
      onTap: () => onStickerSelected(asset),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';

class StickersFrame extends StatefulWidget {
  const StickersFrame({Key? key}) : super(key: key);

  @override
  _StickersFrameState createState() => _StickersFrameState();
}

class _StickersFrameState extends State<StickersFrame> {
  bool displayStickers = false;
  var stickersSelected = <Asset>[];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          right: 15,
          top: 15,
          child: OpenStickersButton(
            onPressed: () {
              setState(() {
                displayStickers = !displayStickers;
              });
            },
          ),
        ),
        if (displayStickers)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickersCarousel(
              onStickerSelected: (sticker) {
                stickersSelected.add(sticker);
                setState(() {});
              },
            ),
          ),
        for (var sticker in stickersSelected)
          ResizebleSticker(
            sticker: sticker,
          ),
      ],
    );
  }
}

class OpenStickersButton extends StatelessWidget {
  const OpenStickersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed.call(),
      child: Image.asset(
        'assets/icons/stickers_icon.png',
        height: 50,
        width: 50,
      ),
    );
  }
}

class StickersCarousel extends StatelessWidget {
  const StickersCarousel({
    Key? key,
    required this.onStickerSelected,
  }) : super(key: key);

  final Function(Asset) onStickerSelected;

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
  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.memory(asset.data),
      onTap: () => onStickerSelected(asset),
    );
  }
}

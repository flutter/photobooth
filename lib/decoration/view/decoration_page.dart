import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DecorationPage extends StatefulWidget {
  const DecorationPage({Key? key, required this.image}) : super(key: key);

  final ImageData image;

  static Route route({required ImageData image}) {
    return MaterialPageRoute(builder: (_) => DecorationPage(image: image));
  }

  @override
  _DecorationPageState createState() => _DecorationPageState();
}

class _DecorationPageState extends State<DecorationPage> {
  bool _displayStickers = false;
  var stickersSelected = <Asset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(data: widget.image.data),
          OpenStickersButton(onPressed: () {
            setState(() {
              _displayStickers = !_displayStickers;
            });
          }),
          for (var sticker in stickersSelected)
            ResizebleSticker(
              sticker: sticker,
            ),
          GoToPreviewButton(image: widget.image),
          const _BackButton(),
          if (_displayStickers)
            StickersCarousel(
              onStickerSelected: (sticker) {
                stickersSelected.add(sticker);
                setState(() {});
              },
            ),
        ],
      ),
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
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, top: 15),
        child: InkWell(
          onTap: onPressed,
          child: Image.asset('assets/icons/stickers_icon.png'),
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

  final Function(Asset) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(15),
        color: Colors.grey.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StickerSelection(
              asset: Assets.dash,
              onStickerSelected: onStickerSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class StickerSelection extends StatelessWidget {
  const StickerSelection({
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

class GoToPreviewButton extends StatelessWidget {
  const GoToPreviewButton({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () =>
              Navigator.of(context).push(PreviewPage.route(image: image)),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 15,
        ),
        child: IconButton(
          key: const Key('decorationPage_backButton_iconButton'),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

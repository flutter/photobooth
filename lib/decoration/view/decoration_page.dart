import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/preview/preview.dart';

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
          _PreviewImage(image: widget.image),
          CustomPaint(
            size: Size(
              widget.image.width.toDouble(),
              widget.image.height.toDouble(),
            ),
            painter: StickerPainter(
                stickers: stickersSelected,
                offset: Offset(
                  widget.image.width / 2,
                  widget.image.height / 2,
                  //size.width / 2,
                  //size.height / 2,
                )),
          ),
          _GoToPreviewButton(image: widget.image),
          const _GoBackButton(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15, top: 15),
              child: IconButton(
                icon: const Icon(Icons.ac_unit),
                onPressed: () {
                  setState(() {
                    _displayStickers = !_displayStickers;
                  });
                },
              ),
            ),
          ),
          if (_displayStickers)
            _StickersCarousel(
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

class StickerPainter extends CustomPainter {
  const StickerPainter({
    required this.stickers,
    required this.offset,
  });

  final List<Asset> stickers;
  final Offset offset;
  @override
  void paint(Canvas canvas, Size size) {
    if (stickers.isEmpty) return;
    for (var sticker in stickers) {
      canvas.drawImage(
        sticker.image,
        offset,
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant StickerPainter oldDelegate) {
    return false;
  }
}

class _StickersCarousel extends StatelessWidget {
  const _StickersCarousel({
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
            _StickerSelection(
              asset: Assets.dash,
              onStickerSelected: onStickerSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _StickerSelection extends StatelessWidget {
  const _StickerSelection({
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

class _GoBackButton extends StatelessWidget {
  const _GoBackButton({Key? key}) : super(key: key);

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
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _GoToPreviewButton extends StatelessWidget {
  const _GoToPreviewButton({
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

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      Uint8List.fromList(image.data),
      errorBuilder: (context, error, stackTrace) {
        return Text('$error, $stackTrace');
      },
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DecorationPage extends StatelessWidget {
  const DecorationPage({Key? key, required this.image}) : super(key: key);

  static Route route({required ImageData image}) {
    return MaterialPageRoute(builder: (_) => DecorationPage(image: image));
  }

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: Container(
            color: Colors.red,
          )),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: PreviewImage(
                        data: image.data,
                      )),
                ),
                RetakeButton(
                  onPressed: () => Navigator.of(context).popUntil(
                      (route) => route is MaterialPageRoute<PhotoboothPage>),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GoNextButton(
              onPressed: () => Navigator.of(context).push(
                PreviewPage.route(image: image),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => DecorationBloc(),
            child: const DecorationView(),
          ),
        ],
      ),
    );
  }
}

class DecorationView extends StatelessWidget {
  const DecorationView({Key? key}) : super(key: key);

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
              stickers: [
                StickerChoice(
                  asset: Assets.dash,
                  onPressed: () {
                    context
                        .read<DecorationBloc>()
                        .add(DecorationStickerSelected(sticker: Assets.dash));
                  },
                ),
              ],
            ),
          ),
        for (final sticker in state.stickers)
          DraggableResizableAsset(asset: sticker),
      ],
    );
  }
}

class GoNextButton extends StatelessWidget {
  const GoNextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        'assets/icons/go_next_button_icon.png',
        height: 100,
        width: 100,
      ),
    );
  }
}

class RetakeButton extends StatelessWidget {
  const RetakeButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        'assets/icons/retake_button_icon.png',
        height: 54,
        width: 66,
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
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        'assets/icons/stickers_button_icon.png',
        height: 54,
        width: 54,
      ),
    );
  }
}

class StickersCarousel extends StatelessWidget {
  const StickersCarousel({Key? key, required this.stickers}) : super(key: key);

  final List<Widget> stickers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(15),
      color: Colors.grey.withOpacity(0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...stickers],
        ),
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
      onTap: onPressed,
      child: Image.memory(
        asset.bytes,
        height: asset.image.height.toDouble(),
        width: asset.image.width.toDouble(),
      ),
    );
  }
}

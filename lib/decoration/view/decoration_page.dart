import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DecorationPage extends StatelessWidget {
  const DecorationPage({
    Key? key,
    required this.image,
    required this.state,
  }) : super(key: key);

  static Route route({
    required CameraImage image,
    required PhotoboothState state,
  }) {
    return MaterialPageRoute(
      builder: (_) => DecorationPage(image: image, state: state),
    );
  }

  final CameraImage image;
  final PhotoboothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(data: image.data),
          if (state.android.isSelected)
            Positioned(
              key: const Key('decorationPage_android_positioned'),
              top: state.android.position.dy,
              left: state.android.position.dx,
              child: Image.memory(
                Assets.android.bytes,
                height: state.android.size.height,
                width: state.android.size.width,
              ),
            ),
          if (state.dash.isSelected)
            Positioned(
              key: const Key('decorationPage_dash_positioned'),
              top: state.dash.position.dy,
              left: state.dash.position.dx,
              child: Image.memory(
                Assets.dash.bytes,
                height: state.dash.size.height,
                width: state.dash.size.width,
              ),
            ),
          if (state.sparky.isSelected)
            Positioned(
              key: const Key('decorationPage_sparky_positioned'),
              top: state.sparky.position.dy,
              left: state.sparky.position.dx,
              child: Image.memory(
                Assets.sparky.bytes,
                height: state.sparky.size.height,
                width: state.sparky.size.width,
              ),
            ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: IconButton(
                key: const Key('decorationPage_back_iconButton'),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.refresh),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                key: const Key('decorationPage_preview_floatingActionButton'),
                onPressed: () => Navigator.of(context).push(
                  PreviewPage.route(image: image),
                ),
                child: const Icon(Icons.arrow_forward),
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

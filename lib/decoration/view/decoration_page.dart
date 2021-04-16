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
    return BlocProvider(
      create: (context) => DecorationBloc(),
      child: DecorationView(
        image: image,
        state: state,
      ),
    );
  }
}

class DecorationView extends StatelessWidget {
  const DecorationView({
    Key? key,
    required this.image,
    required this.state,
  }) : super(key: key);

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
          Positioned(
            right: 15,
            top: 15,
            child: OpenStickersButton(
              onPressed: () {
                context
                    .read<DecorationBloc>()
                    .add(const DecorationModeToggled());
              },
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
          BlocBuilder<DecorationBloc, DecorationState>(
            buildWhen: (previous, current) =>
                previous.stickers.length != current.stickers.length,
            builder: (context, state) {
              if (state.stickers.isEmpty) return const SizedBox();
              return _DraggableStickers(stickers: state.stickers);
            },
          ),
          BlocBuilder<DecorationBloc, DecorationState>(
            buildWhen: (previous, current) => previous.mode != current.mode,
            builder: (context, state) {
              if (state.mode.isActive)
                return const Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: StickersDrawer(),
                );
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _DraggableStickers extends StatelessWidget {
  const _DraggableStickers({
    Key? key,
    required this.stickers,
  }) : super(key: key);

  final List<Asset> stickers;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final sticker in stickers) DraggableResizableAsset(asset: sticker),
      ],
    );
  }
}

@visibleForTesting
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

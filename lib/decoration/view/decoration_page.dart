import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/decoration/widgets/stickers_drawer.dart';
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
    return BlocProvider(
        create: (context) => DecorationBloc(),
        child: DecorationView(image: image));
  }
}

class DecorationView extends StatelessWidget {
  const DecorationView({Key? key, required this.image}) : super(key: key);
  final ImageData image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(data: image.data),
          Positioned(
            left: 15,
            top: 15,
            child: IconButton(
              key: const Key('decorationPage_back_iconButton'),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.refresh),
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
                child: const Icon(Icons.arrow_forward),
                onPressed: () => Navigator.of(context).push(
                  PreviewPage.route(image: image),
                ),
              ),
            ),
          ),
          BlocBuilder<DecorationBloc, DecorationState>(
            buildWhen: (previous, current) =>
                previous.stickers.length != current.stickers.length,
            builder: (context, state) {
              if (state.stickers.isEmpty) return const SizedBox();
              return Stack(
                fit: StackFit.expand,
                children: [
                  for (final sticker in state.stickers)
                    DraggableResizableAsset(asset: sticker),
                ],
              );
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

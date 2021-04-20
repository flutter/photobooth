import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class StickersPage extends StatelessWidget {
  const StickersPage({
    Key? key,
    required this.image,
  }) : super(key: key);

  static Route route({
    required CameraImage image,
    required PhotoboothBloc photoboothBloc,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: photoboothBloc,
        child: StickersPage(image: image),
      ),
    );
  }

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersBloc(),
      child: StickersView(image: image),
    );
  }
}

class StickersView extends StatelessWidget {
  const StickersView({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/wood_background.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Center(
            child: AspectRatio(
              aspectRatio: isMobile ? 3 / 4 : 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PreviewImage(data: image.data),
                  const CharactersLayer(),
                  BlocBuilder<StickersBloc, StickersState>(
                    builder: (context, state) {
                      if (state.stickers.isEmpty) return const SizedBox();
                      return _DraggableStickers(stickers: state.stickers);
                    },
                  ),
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Row(
                      children: [
                        RetakeButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 15),
                        const _ClearStickersButton(),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: OpenStickersButton(
                      onPressed: () {
                        context
                            .read<StickersBloc>()
                            .add(const StickersModeToggled());
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NextButton(
                      onPressed: () => Navigator.of(context).push(
                        SharePage.route(
                          image: image,
                          photoboothBloc: context.read<PhotoboothBloc>(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<StickersBloc, StickersState>(
            buildWhen: (previous, current) => previous.mode != current.mode,
            builder: (context, state) {
              return state.mode.isActive
                  ? const Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: StickersDrawer(),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class CharactersLayer extends StatefulWidget {
  const CharactersLayer({Key? key, this.scale = 1}) : super(key: key);

  final double scale;

  @override
  _CharactersLayerState createState() => _CharactersLayerState();
}

class _CharactersLayerState extends State<CharactersLayer> {
  Size? initialSize;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    return LayoutBuilder(
      builder: (context, constraints) {
        initialSize ??= Size(constraints.maxWidth, constraints.maxHeight);

        final widthFactor = constraints.maxWidth / initialSize!.width;
        final heightFactor = constraints.maxHeight / initialSize!.height;

        return Stack(
          children: [
            if (state.android.isSelected)
              Positioned(
                key: const Key('stickersView_android_positioned'),
                top: state.android.position.dy * heightFactor * widget.scale,
                left: state.android.position.dx * widthFactor * widget.scale,
                child: Image.memory(
                  Assets.android.bytes,
                  height:
                      state.android.size.height * heightFactor * widget.scale,
                  width: state.android.size.width * widthFactor * widget.scale,
                ),
              ),
            if (state.dash.isSelected)
              Positioned(
                key: const Key('stickersView_dash_positioned'),
                top: state.dash.position.dy * heightFactor * widget.scale,
                left: state.dash.position.dx * widthFactor * widget.scale,
                child: Image.memory(
                  Assets.dash.bytes,
                  height: state.dash.size.height * heightFactor * widget.scale,
                  width: state.dash.size.width * widthFactor * widget.scale,
                ),
              ),
            if (state.sparky.isSelected)
              Positioned(
                key: const Key('stickersView_sparky_positioned'),
                top: state.sparky.position.dy * heightFactor * widget.scale,
                left: state.sparky.position.dx * widthFactor * widget.scale,
                child: Image.memory(
                  Assets.sparky.bytes,
                  height:
                      state.sparky.size.height * heightFactor * widget.scale,
                  width: state.sparky.size.width * widthFactor * widget.scale,
                ),
              ),
          ],
        );
      },
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

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      color: PhotoboothColors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/icons/go_next_button_icon.png',
          height: 100,
        ),
      ),
    );
  }
}

class _ClearStickersButton extends StatelessWidget {
  const _ClearStickersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHidden = context.select(
      (StickersBloc bloc) => bloc.state.stickers.isEmpty,
    );

    if (isHidden) return const SizedBox();
    return ClearStickersButton(
      onPressed: () {
        context.read<StickersBloc>().add(const StickersCleared());
      },
    );
  }
}

class ClearStickersButton extends StatelessWidget {
  const ClearStickersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: PhotoboothColors.transparent,
      child: Tooltip(
        message: l10n.clearStickersButtonTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset('assets/icons/delete_icon.png', height: 50),
        ),
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
    final l10n = context.l10n;
    return Material(
      color: PhotoboothColors.transparent,
      child: Tooltip(
        message: l10n.retakeButtonTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            'assets/icons/retake_button_icon.png',
            height: 54,
          ),
        ),
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
    final l10n = context.l10n;
    return Material(
      color: PhotoboothColors.transparent,
      child: Tooltip(
        message: l10n.openStickersTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            'assets/icons/stickers_button_icon.png',
            height: 50,
          ),
        ),
      ),
    );
  }
}

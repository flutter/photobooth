import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class StickersPage extends StatelessWidget {
  const StickersPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const StickersPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersBloc(),
      child: const StickersView(),
    );
  }
}

class StickersView extends StatelessWidget {
  const StickersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
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
                  if (image != null) PreviewImage(data: image.data),
                  const MadeWithIconLinks(),
                  const CharactersLayer(),
                  BlocBuilder<PhotoboothBloc, PhotoboothState>(
                    builder: (context, state) {
                      if (state.stickers.isEmpty) return const SizedBox();
                      return _DraggableStickers(
                        stickers: state.stickers.map((s) => s.asset).toList(),
                      );
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
                            .add(const StickersDrawerToggled());
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NextButton(
                      onPressed: () {
                        Navigator.of(context).push(SharePage.route());
                      },
                    ),
                  ),
                  _StickersDrawer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickersDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDrawerActive = context.select(
      (StickersBloc bloc) => bloc.state.isDrawerActive,
    );
    return isDrawerActive
        ? const Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: StickersDrawer(),
          )
        : const SizedBox();
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
        for (final sticker in stickers)
          DraggableResizableAsset(
            asset: sticker,
            onUpdate: (update) => context
                .read<PhotoboothBloc>()
                .add(PhotoStickerDragged(sticker: sticker, update: update)),
          ),
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
      (PhotoboothBloc bloc) => bloc.state.stickers.isEmpty,
    );

    if (isHidden) return const SizedBox();
    return ClearStickersButton(
      onPressed: () {
        context.read<PhotoboothBloc>().add(const PhotoClearStickersTapped());
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

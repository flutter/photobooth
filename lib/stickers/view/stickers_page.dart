import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _initialStickerScale = 0.25;
const _minStickerScale = 0.1;

class StickersPage extends StatelessWidget {
  const StickersPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return AppPageRoute(builder: (_) => const StickersPage());
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
    final state = context.watch<PhotoboothBloc>().state;
    final image = state.image;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PhotoboothBackground(),
          Center(
            child: AspectRatio(
              aspectRatio: state.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: PhotoboothColors.black),
                  ),
                  if (image != null) PreviewImage(data: image.data),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 24),
                      child: MadeWithIconLinks(),
                    ),
                  ),
                  const CharactersLayer(),
                  const _DraggableStickers(),
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Row(
                      children: [
                        RetakeButton(
                          onPressed: () {
                            context
                                .read<PhotoboothBloc>()
                                .add(const PhotoClearAllTapped());
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 15),
                        const ClearStickersButtonLayer(),
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
                      onPressed: () =>
                          Navigator.of(context).push(SharePage.route()),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: _StickerReminderText(),
                  )
                ],
              ),
            ),
          ),
          BlocListener<StickersBloc, StickersState>(
            listenWhen: (previous, current) =>
                isMobile && current.isDrawerActive && current != previous,
            listener: (context, state) async {
              await showModalBottomSheet(
                context: context,
                barrierColor: PhotoboothColors.black.withOpacity(0.75),
                backgroundColor: PhotoboothColors.transparent,
                isScrollControlled: true,
                builder: (_) => MobileStickersDrawer(
                  onStickerSelected: (sticker) => context
                      .read<PhotoboothBloc>()
                      .add(PhotoStickerTapped(sticker: sticker)),
                ),
              );
              context.read<StickersBloc>().add(const StickersDrawerToggled());
            },
            child: const StickersDrawerLayer(),
          ),
        ],
      ),
    );
  }
}

class _StickerReminderText extends StatelessWidget {
  const _StickerReminderText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final shouldDisplayPropsReminder = context.select(
      (StickersBloc bloc) => bloc.state.shouldDisplayPropsReminder,
    );

    if (!shouldDisplayPropsReminder) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 125),
      child: AppTooltip.custom(
        key: const Key('stickersPage_propsReminder_appTooltip'),
        visible: true,
        message: context.l10n.propsReminderText,
        padding: const EdgeInsets.all(24),
      ),
    );
  }
}

class _DraggableStickers extends StatelessWidget {
  const _DraggableStickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    if (state.stickers.isEmpty) return const SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const Key('stickersView_background_gestureDetector'),
            onTap: () {
              context.read<PhotoboothBloc>().add(const PhotoTapped());
            },
          ),
        ),
        for (final sticker in state.stickers)
          DraggableResizable(
            key: Key('stickerPage_${sticker.id}_draggableResizable_asset'),
            canTransform: sticker.id == state.selectedAssetId,
            onUpdate: (update) => context
                .read<PhotoboothBloc>()
                .add(PhotoStickerDragged(sticker: sticker, update: update)),
            onDelete: () => context
                .read<PhotoboothBloc>()
                .add(const PhotoDeleteSelectedStickerTapped()),
            size: sticker.getImageSize() * _initialStickerScale,
            constraints: sticker.getImageConstraints(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.memory(
                sticker.asset.bytes,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
          ),
      ],
    );
  }
}

extension on PhotoAsset {
  Size getImageSize() {
    return Size(
      asset.image.width.toDouble(),
      asset.image.height.toDouble(),
    );
  }

  BoxConstraints getImageConstraints() {
    return BoxConstraints(
      minWidth: asset.image.width * _minStickerScale,
      minHeight: asset.image.height * _minStickerScale,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
    );
  }
}

class OpenStickersButton extends StatelessWidget {
  const OpenStickersButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppTooltipButton(
      onPressed: onPressed,
      message: l10n.openStickersTooltip,
      mode: TooltipMode.normal,
      child: Image.asset('assets/icons/stickers_button_icon.png', height: 100),
    );
  }
}

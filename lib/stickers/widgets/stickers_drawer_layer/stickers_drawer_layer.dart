import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersDrawerLayer extends StatefulWidget {
  const StickersDrawerLayer({Key? key}) : super(key: key);

  @override
  State<StickersDrawerLayer> createState() => _StickersDrawerLayerState();
}

class _StickersDrawerLayerState extends State<StickersDrawerLayer> {
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StickersBloc, StickersState>(
      listenWhen: (previous, current) =>
          current.isDrawerActive && current != previous,
      listener: (context, state) {
        if (MediaQuery.of(context).size.width < PhotoboothBreakpoints.small) {
          showModalBottomSheet<void>(
            context: context,
            barrierColor: PhotoboothColors.black.withOpacity(0.75),
            backgroundColor: PhotoboothColors.transparent,
            isScrollControlled: true,
            builder: (_) => MobileStickersDrawer(
              initialIndex: state.tabIndex,
              bucket: _bucket,
              onTabChanged: (index) => context
                  .read<StickersBloc>()
                  .add(StickersDrawerTabTapped(index: index)),
              onStickerSelected: (sticker) {
                context
                    .read<PhotoboothBloc>()
                    .add(PhotoStickerTapped(sticker: sticker));
                Navigator.of(context).pop();
              },
            ),
          );
          context.read<StickersBloc>().add(const StickersDrawerToggled());
        }
      },
      buildWhen: (previous, current) => current != previous,
      builder: (context, state) {
        if (state.isDrawerActive &&
            MediaQuery.of(context).size.width >= PhotoboothBreakpoints.small) {
          return Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: DesktopStickersDrawer(
              initialIndex: state.tabIndex,
              bucket: _bucket,
              onTabChanged: (index) => context
                  .read<StickersBloc>()
                  .add(StickersDrawerTabTapped(index: index)),
              onStickerSelected: (sticker) {
                context.read<StickersBloc>().add(const StickersDrawerToggled());
                context
                    .read<PhotoboothBloc>()
                    .add(PhotoStickerTapped(sticker: sticker));
              },
              onCloseTapped: () => context
                  .read<StickersBloc>()
                  .add(const StickersDrawerToggled()),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

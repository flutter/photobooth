import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersDrawerLayer extends StatelessWidget {
  StickersDrawerLayer({Key? key}) : super(key: key);

  final PageStorageBucket pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StickersBloc, StickersState>(
      listenWhen: (previous, current) =>
          current.isDrawerActive && current != previous,
      listener: (context, state) {
        if (MediaQuery.of(context).size.width < PhotoboothBreakpoints.small) {
          showModalBottomSheet(
            context: context,
            barrierColor: PhotoboothColors.black.withOpacity(0.75),
            backgroundColor: PhotoboothColors.transparent,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<StickersBloc>(),
              child: MobileStickersDrawer(
                bucket: pageStorageBucket,
                onStickerSelected: (sticker) => context
                    .read<PhotoboothBloc>()
                    .add(PhotoStickerTapped(sticker: sticker)),
              ),
            ),
          );
          context.read<StickersBloc>().add(const StickersDrawerToggled());
        }
      },
      buildWhen: (previous, current) => current != previous,
      builder: (context, state) {
        if (MediaQuery.of(context).size.width >= PhotoboothBreakpoints.small &&
            state.isDrawerActive)
          return Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: DesktopStickersDrawer(bucket: pageStorageBucket),
          );
        return const SizedBox();
      },
    );
  }
}

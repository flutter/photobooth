import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class RemoveSelectedStickerButtonLayer extends StatelessWidget {
  RemoveSelectedStickerButtonLayer({
    Key? key,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    if (!platformHelper.isMobile) return const SizedBox();
    final isHidden = context.select(
      (PhotoboothBloc bloc) => bloc.state.selectedAssetId == emptyAssetId,
    );

    if (isHidden) return const SizedBox();
    return RemoveSelectedStickerButton(
      onPressed: () {
        context
            .read<PhotoboothBloc>()
            .add(const PhotoDeleteSelectedStickerTapped());
      },
    );
  }
}

@visibleForTesting
class RemoveSelectedStickerButton extends StatelessWidget {
  const RemoveSelectedStickerButton({
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
          'assets/icons/trash_icon.png',
          height: 100,
        ),
      ),
    );
  }
}

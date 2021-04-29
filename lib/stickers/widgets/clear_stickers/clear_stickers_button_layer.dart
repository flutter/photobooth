import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ClearStickersButtonLayer extends StatelessWidget {
  const ClearStickersButtonLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHidden = context.select(
      (PhotoboothBloc bloc) => bloc.state.stickers.isEmpty,
    );

    return Visibility(
      maintainState: true,
      visible: !isHidden,
      child: ClearStickersButton(
        willDisplayTooltipAutomatically: !isHidden,
        onPressed: () async {
          context.read<StickersBloc>().add(const StickersClearTooltipShowed());
          final confirmed = await showAppDialog(
            context: context,
            child: const ClearStickersDialog(),
          );
          if (confirmed)
            context
                .read<PhotoboothBloc>()
                .add(const PhotoClearStickersTapped());
        },
      ),
    );
  }
}

@visibleForTesting
class ClearStickersButton extends StatelessWidget {
  const ClearStickersButton({
    Key? key,
    required this.onPressed,
    required this.willDisplayTooltipAutomatically,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool willDisplayTooltipAutomatically;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: PhotoboothColors.transparent,
      child: AnimatedTooltip(
        message: l10n.clearStickersButtonTooltip,
        willDisplayTooltipAutomatically: willDisplayTooltipAutomatically,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset('assets/icons/delete_icon.png', height: 54),
        ),
      ),
    );
  }
}

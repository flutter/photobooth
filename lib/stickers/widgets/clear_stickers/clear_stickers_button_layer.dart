import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ClearStickersButtonLayer extends StatelessWidget {
  const ClearStickersButtonLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHidden = context.select(
      (PhotoboothBloc bloc) => bloc.state.stickers.isEmpty,
    );

    if (isHidden) return const SizedBox();
    return ClearStickersButton(
      onPressed: () async {
        final confirmed = await showAppDialog(
          context: context,
          child: const ClearStickersDialog(),
        );
        if (confirmed) {
          context.read<PhotoboothBloc>().add(const PhotoClearStickersTapped());
        }
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
    return Semantics(
      focusable: true,
      button: true,
      label: l10n.clearAllStickersButtonLabelText,
      child: AppTooltipButton(
        onPressed: onPressed,
        message: l10n.clearStickersButtonTooltip,
        verticalOffset: 50,
        child: Image.asset('assets/icons/delete_icon.png', height: 100),
      ),
    );
  }
}

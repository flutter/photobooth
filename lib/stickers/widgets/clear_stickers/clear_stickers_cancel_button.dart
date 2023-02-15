import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ClearStickersCancelButton extends StatelessWidget {
  const ClearStickersCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: PhotoboothColors.black,
        side: const BorderSide(color: PhotoboothColors.black),
      ),
      onPressed: () => Navigator.of(context).pop(false),
      child: Text(
        l10n.clearStickersDialogCancelButtonText,
      ),
    );
  }
}

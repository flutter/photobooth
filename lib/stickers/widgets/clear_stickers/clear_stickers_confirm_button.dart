import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ClearStickersConfirmButton extends StatelessWidget {
  const ClearStickersConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: Text(l10n.clearStickersDialogConfirmButtonText),
    );
  }
}

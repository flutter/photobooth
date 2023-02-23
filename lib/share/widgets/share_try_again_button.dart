import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ShareTryAgainButton extends StatelessWidget {
  const ShareTryAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(l10n.shareErrorDialogTryAgainButton),
    );
  }
}

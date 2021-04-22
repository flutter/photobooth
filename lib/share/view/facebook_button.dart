import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {},
      child: Text(l10n.shareDialogFacebookButtonText),
    );
  }
}

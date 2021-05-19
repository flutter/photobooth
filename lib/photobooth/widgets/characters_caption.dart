import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharactersCaption extends StatelessWidget {
  const CharactersCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: false,
      child: AppTooltip.custom(
        visible: true,
        message: l10n.charactersCaptionText,
      ),
    );
  }
}

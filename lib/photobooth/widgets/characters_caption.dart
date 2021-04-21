import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class CharactersCaption extends StatelessWidget {
  const CharactersCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: const BoxDecoration(
        color: PhotoboothColors.blue,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        l10n.charactersCaptionText,
        style: const TextStyle(
          color: PhotoboothColors.white,
          fontWeight: PhotoboothFontWeight.regular,
          fontSize: 15,
        ),
      ),
    );
  }
}

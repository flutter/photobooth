import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class CharactersCaption extends StatelessWidget {
  const CharactersCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Container(
      decoration: theme.tooltipTheme.decoration,
      padding: theme.tooltipTheme.padding,
      child: Text(
        l10n.charactersCaptionText,
        style: theme.tooltipTheme.textStyle,
      ),
    );
  }
}

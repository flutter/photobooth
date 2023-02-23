import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareHeading extends StatelessWidget {
  const ShareHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SelectableText(
      l10n.sharePageHeading,
      style: theme.textTheme.displayLarge?.copyWith(
        color: PhotoboothColors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ShareSuccessHeading extends StatelessWidget {
  const ShareSuccessHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SelectableText(
      l10n.sharePageSuccessHeading,
      style: theme.textTheme.displayLarge?.copyWith(
        color: PhotoboothColors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ShareErrorHeading extends StatelessWidget {
  const ShareErrorHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SelectableText(
      l10n.sharePageErrorHeading,
      style: theme.textTheme.displayLarge?.copyWith(
        color: PhotoboothColors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

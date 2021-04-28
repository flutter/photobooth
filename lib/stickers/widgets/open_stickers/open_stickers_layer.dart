import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenStickersButtonLayer extends StatelessWidget {
  const OpenStickersButtonLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OpenStickersButton(
          onPressed: () =>
              context.read<StickersBloc>().add(const StickersDrawerToggled()),
        ),
        OpenStickersTooltip(),
      ],
    );
  }
}

@visibleForTesting
class OpenStickersButton extends StatelessWidget {
  const OpenStickersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: PhotoboothColors.transparent,
      child: Tooltip(
        message: l10n.openStickersTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            'assets/icons/stickers_button_icon.png',
            height: 50,
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class OpenStickersTooltip extends StatelessWidget {
  const OpenStickersTooltip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context).tooltipTheme;
    return Container(
      color: PhotoboothColors.tooltipBackgroundColor,
      padding: theme.padding,
      child: Text(
        l10n.openStickersTooltip,
        style: theme.textStyle,
      ),
    );
  }
}

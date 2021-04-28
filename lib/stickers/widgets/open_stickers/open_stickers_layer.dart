import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenStickersButtonLayer extends StatelessWidget {
  const OpenStickersButtonLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: 100,
      child: Column(
        children: [
          OpenStickersButton(
            onPressed: () =>
                context.read<StickersBloc>().add(const StickersDrawerToggled()),
          ),
          BlocBuilder<StickersBloc, StickersState>(
            buildWhen: (previous, current) => isMobile,
            builder: (context, state) {
              return Visibility(
                visible: state.displayOpenStickersTooltip,
                child: AppPersistentTooltip(text: l10n.openStickersTooltip),
              );
            },
          )
        ],
      ),
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

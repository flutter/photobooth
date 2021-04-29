import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ClearStickersButtonLayer extends StatefulWidget {
  const ClearStickersButtonLayer({Key? key}) : super(key: key);

  @override
  _ClearStickersButtonLayerState createState() =>
      _ClearStickersButtonLayerState();
}

class _ClearStickersButtonLayerState extends State<ClearStickersButtonLayer> {
  bool firstTime = true;
  @override
  Widget build(BuildContext context) {
    final isHidden = context.select(
      (PhotoboothBloc bloc) => bloc.state.stickers.isEmpty,
    );
    if (isHidden && firstTime) {
      firstTime = false;
      return const SizedBox();
    }

    return Visibility(
      maintainState: true,
      visible: !isHidden,
      child: ClearStickersButton(
        onPressed: () async {
          final confirmed = await showAppDialog(
            context: context,
            child: const ClearStickersDialog(),
          );
          if (confirmed)
            context
                .read<PhotoboothBloc>()
                .add(const PhotoClearStickersTapped());
        },
      ),
    );
  }
}

@visibleForTesting
class ClearStickersButton extends StatelessWidget {
  const ClearStickersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: PhotoboothColors.transparent,
      child: AnimatedTooltip(
        message: l10n.clearStickersButtonTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset('assets/icons/delete_icon.png', height: 54),
        ),
      ),
    );
  }
}

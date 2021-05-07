import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersCaption extends StatelessWidget {
  const StickersCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final small =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return Align(
      alignment: small ? Alignment.center : const Alignment(0.0, 0.6),
      child: AppTooltip.custom(
        visible: true,
        message: l10n.propsHelperText,
        padding: EdgeInsets.all(small ? 15 : 30),
      ),
    );
  }
}

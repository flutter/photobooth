import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class RetakeButton extends StatelessWidget {
  const RetakeButton({
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
        message: l10n.retakeButtonTooltip,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            'assets/icons/retake_button_icon.png',
            height: 54,
          ),
        ),
      ),
    );
  }
}

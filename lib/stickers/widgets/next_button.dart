import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

@visibleForTesting
class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      color: PhotoboothColors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/icons/go_next_button_icon.png',
          height: 100,
        ),
      ),
    );
  }
}

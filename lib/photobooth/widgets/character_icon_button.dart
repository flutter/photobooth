import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _characterIconButtonSizeLandscape = 90.0;
const _characterIconButtonSizePortait = 60.0;

class CharacterIconButton extends StatelessWidget {
  const CharacterIconButton({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  final AssetImage icon;
  final VoidCallback? onPressed;
  final bool isSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Semantics(
      focusable: true,
      button: true,
      label: label,
      onTap: onPressed,
      child: Opacity(
        opacity: isSelected ? 0.6 : 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: PhotoboothColors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: Ink.image(
              fit: BoxFit.cover,
              image: icon,
              width: orientation == Orientation.landscape
                  ? _characterIconButtonSizeLandscape
                  : _characterIconButtonSizePortait,
              height: orientation == Orientation.landscape
                  ? _characterIconButtonSizeLandscape
                  : _characterIconButtonSizePortait,
              child: InkWell(onTap: onPressed),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template tooltip_mode}
/// The tooltip mode which determines when the tooltip is visible
/// {@endtemplate}
enum TooltipMode {
  /// Default tooltip behavior
  normal,

  /// Tooltip is always visible until the user interacts with the button.
  visibleUntilInteraction
}

/// {@template app_tooltip_button}
/// An [AppTooltip] button which handles showing a tooltip based on the
/// [TooltipMode].
/// {@endtemplate}
class AppTooltipButton extends StatefulWidget {
  /// {@macro app_tooltip_button}
  const AppTooltipButton({
    required this.onPressed,
    required this.message,
    required this.child,
    this.mode = TooltipMode.normal,
    this.verticalOffset,
    super.key,
  });

  /// [VoidCallback] which is invoked when the user taps the [child].
  final VoidCallback onPressed;

  /// Message to be shown in the tooltip.
  final String message;

  /// {@macro tooltip_mode}
  final TooltipMode mode;

  /// The tooltip's vertical offset.
  final double? verticalOffset;

  /// The widget which will be rendered.
  final Widget child;

  @override
  State<AppTooltipButton> createState() => _AppTooltipButtonState();
}

class _AppTooltipButtonState extends State<AppTooltipButton> {
  var _hasBeenTapped = false;

  bool get _isTooltipVisible =>
      widget.mode == TooltipMode.visibleUntilInteraction && !_hasBeenTapped;

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      onTap: () {
        setState(() => _hasBeenTapped = true);
        widget.onPressed();
      },
      child: widget.child,
    );
    return Material(
      color: PhotoboothColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: AppTooltip.custom(
        visible: _isTooltipVisible,
        message: widget.message,
        verticalOffset: widget.verticalOffset,
        child: child,
      ),
    );
  }
}

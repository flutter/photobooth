import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

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
  AppTooltipButton({
    Key? key,
    required this.onPressed,
    required this.message,
    this.mode = TooltipMode.normal,
    PlatformHelper? platformHelper,
    required this.child,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// [VoidCallback] which is invoked when the user taps the [child].
  final VoidCallback onPressed;

  /// Message to be shown in the tooltip.
  final String message;

  /// {@macro tooltip_mode}
  final TooltipMode mode;

  /// An instance of [PlatformHelper] which is used to determine the tooltip
  /// visibility based on the underlying platform.
  final PlatformHelper platformHelper;

  /// The widget which will be rendered.
  final Widget child;

  @override
  _AppTooltipButtonState createState() => _AppTooltipButtonState();
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
      child: widget.platformHelper.isMobile
          ? AppTooltip.custom(
              visible: _isTooltipVisible,
              message: widget.message,
              child: child,
            )
          : AppTooltip(message: widget.message, child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template app_tooltip}
/// A custom [Tooltip] for the photobooth_ui toolkit.
/// {@endtemplate}
class AppTooltip extends StatelessWidget {
  /// {@macro app_tooltip}
  const AppTooltip({
    required String message,
    required Widget child,
    EdgeInsets? padding,
    Key? key,
  }) : this._(
          key: key,
          message: message,
          child: child,
          padding: padding,
        );

  const AppTooltip._({
    required this.message,
    required this.child,
    this.visible = false,
    this.padding,
    this.verticalOffset,
    super.key,
  });

  /// {@macro app_tooltip}
  const AppTooltip.custom({
    required String message,
    required bool visible,
    EdgeInsets? padding,
    double? verticalOffset,
    Widget? child,
    Key? key,
  }) : this._(
          key: key,
          message: message,
          visible: visible,
          padding: padding,
          verticalOffset: verticalOffset,
          child: child,
        );

  /// The tooltip message.
  final String message;

  /// Whether or not the tooltip is currently visible.
  final bool visible;

  /// An optional padding.
  final EdgeInsets? padding;

  /// An optional vertical offset.
  final double? verticalOffset;

  /// An optional child widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final child = this.child;

    if (visible) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) child,
          Container(
            decoration: const BoxDecoration(
              color: PhotoboothColors.charcoal,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: padding ?? const EdgeInsets.all(10),
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: PhotoboothColors.white),
            ),
          ),
        ],
      );
    }
    return Tooltip(
      message: message,
      verticalOffset: verticalOffset,
      child: child,
    );
  }
}

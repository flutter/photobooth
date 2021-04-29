import 'dart:async';

import 'package:flutter/material.dart';

const int _maxDuration = 999;

/// {@template animated_tooltip}
/// Abstraction of a [Tooltip] that can be automatically displayed
/// {@endtemplate}
class AnimatedTooltip extends StatefulWidget {
  /// {@macro animated_tooltip}

  const AnimatedTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.willDisplayTooltipAutomatically = true,
    this.isPersistent = false,
  }) : super(key: key);

  ///Text to display on the tooltip

  final String message;

  /// [Widget] under the tooltip will be displayed
  final Widget child;

  /// When the tooltip will be displayed automatically or not
  final bool willDisplayTooltipAutomatically;

  /// Whether the tooltip is persistent or not

  final bool isPersistent;

  @override
  _AnimatedTooltipState createState() => _AnimatedTooltipState();
}

class _AnimatedTooltipState extends State<AnimatedTooltip> {
  late final Timer startingTimer;
  late final Timer endTimer;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.willDisplayTooltipAutomatically) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        final dynamic tooltip = key.currentState;
        startingTimer = Timer(const Duration(seconds: 1), () {
          tooltip.ensureTooltipVisible();
        });
        if (!widget.isPersistent)
          endTimer = Timer(const Duration(seconds: 3), () {
            tooltip.deactivate();
          });
      });
    }
  }

  @override
  void dispose() {
    endTimer.cancel();
    startingTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: key,
      message: widget.message,
      showDuration: Duration(
        seconds: widget.isPersistent ? _maxDuration : 3,
      ),
      child: widget.child,
    );
  }
}

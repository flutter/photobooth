// ignore_for_file: avoid_dynamic_calls
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
    this.isPersistent = false,
  }) : super(key: key);

  ///Text to display on the tooltip
  final String message;

  /// [Widget] under the tooltip will be displayed
  final Widget child;

  /// Whether the tooltip is persistent or not
  final bool isPersistent;

  @override
  _AnimatedTooltipState createState() => _AnimatedTooltipState();
}

class _AnimatedTooltipState extends State<AnimatedTooltip> {
  Timer? startingTimer;
  Timer? endTimer;
  final globalKey = GlobalKey();

  @override
  void dispose() {
    if (!widget.isPersistent) {
      endTimer?.cancel();
    }
    startingTimer?.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (isMobile) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        final dynamic tooltip = globalKey.currentState;
        // We need to delay the tooltip, else will be displayed inconsistenly
        // on the screen while navigating
        startingTimer = Timer(const Duration(milliseconds: 500), () {
          tooltip.ensureTooltipVisible();
          if (!widget.isPersistent)
            endTimer = Timer(const Duration(seconds: 3), tooltip.deactivate);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: globalKey,
      message: widget.message,
      showDuration: Duration(
        seconds: widget.isPersistent ? _maxDuration : 3,
      ),
      child: widget.child,
    );
  }
}

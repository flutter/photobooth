import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template animated_tooltip}
/// Display a [text] on a AppTooltip for a [duration], default to 3 seconds.
/// After the given [duration] will be dismissed
/// {@endtemplate}
class AnimatedTooltip extends StatefulWidget {
  /// {@macro animated_tooltip}
  AnimatedTooltip({
    Key? key,
    required this.text,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  ///Text to display on the tooltip
  final String text;

  ///Duration tooltip is visible
  final Duration duration;

  @override
  _AnimatedTooltipState createState() => _AnimatedTooltipState();
}

class _AnimatedTooltipState extends State<AnimatedTooltip> {
  late final Timer timer;
  var _isTooltipVisible = true;
  @override
  void initState() {
    super.initState();

    timer = Timer(widget.duration, () {
      setState(() {
        _isTooltipVisible = false;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isTooltipVisible ? 1.0 : 0.0,
      child: AppTooltip(text: widget.text),
    );
  }
}

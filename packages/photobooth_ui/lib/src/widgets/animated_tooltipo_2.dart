import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedTooltip2 extends StatefulWidget {
  const AnimatedTooltip2({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  final String message;
  final Widget child;

  @override
  _AnimatedTooltip2State createState() => _AnimatedTooltip2State();
}

class _AnimatedTooltip2State extends State<AnimatedTooltip2> {
  late final Timer timer;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final dynamic tooltip = key.currentState;
      tooltip.ensureTooltipVisible();
      timer = Timer(const Duration(seconds: 3), () {
        tooltip.deactivate();
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
    return Tooltip(
      key: key,
      message: widget.message,
      child: widget.child,
    );
  }
}

import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:flutter/material.dart';

/// Type for the update `builder` function of [AdaptiveBuilder]
typedef AdaptiveWidgetBuilder = Widget Function(BuildContext, WindowBreakpoint);

/// {@template adaptive_builder}
/// Provides updates of the size of the window [WindowBreakpoint] that hosts
/// the application
/// {@endtemplate}
class AdaptiveBuilder extends StatelessWidget {
  /// {@macro adaptive_builder}
  const AdaptiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Callback that triggers when a change requires a new [WindowBreakpoint]
  final AdaptiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.windowBreakpoint);
  }
}

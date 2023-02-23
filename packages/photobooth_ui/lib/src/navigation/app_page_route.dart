import 'package:flutter/material.dart';

/// {@template app_page_route}
/// Default [MaterialPageRoute] for the `photobooth_ui` toolkit.
/// This page route disables all transition animations.
/// {@endtemplate}
class AppPageRoute<T> extends MaterialPageRoute<T> {
  /// {@macro app_page_route}
  AppPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

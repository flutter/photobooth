import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/src/layout/layout.dart';

/// Signature for the individual builders (`mobile`, `desktop`, etc.).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    Key? key,
    required this.mobile,
    required this.desktop,
    this.wideDesktop,
    this.child,
  }) : super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for mobile layout.
  final ResponsiveLayoutWidgetBuilder mobile;

  /// [ResponsiveLayoutWidgetBuilder] for desktop layout.
  final ResponsiveLayoutWidgetBuilder desktop;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.

  final ResponsiveLayoutWidgetBuilder? wideDesktop;

  /// Optional child widget which will be passed to the `mobile` and `desktop`
  /// builders as a way to share/optimize shared layout.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= PhotoboothBreakpoints.mobile)
          return mobile(context, child);
        if (constraints.maxWidth <= PhotoboothBreakpoints.desktop)
          return desktop(context, child);
        if (wideDesktop == null) return desktop(context, child);

        return wideDesktop!(context, child);
      },
    );
  }
}

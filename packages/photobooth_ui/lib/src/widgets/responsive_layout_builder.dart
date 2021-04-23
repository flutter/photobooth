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
    this.child,
  }) : super(key: key);

  /// [WidgetBuilder] for mobile layout.
  final ResponsiveLayoutWidgetBuilder mobile;

  /// [WidgetBuilder] for desktop layout.
  final ResponsiveLayoutWidgetBuilder desktop;

  /// Optional child widget which will be passed to the `mobile` and `desktop`
  /// builders as a way to share/optimize shared layout.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth <= PhotoboothBreakpoints.mobile
            ? mobile(context, child)
            : desktop(context, child);
      },
    );
  }
}

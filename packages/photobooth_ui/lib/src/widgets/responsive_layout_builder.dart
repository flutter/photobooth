import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/src/layout/layout.dart';

/// Signature for the individual builders (`small`, `large`, etc.).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    required this.small,
    required this.large,
    this.medium,
    this.xLarge,
    this.child,
    super.key,
  });

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder? medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// [ResponsiveLayoutWidgetBuilder] for xLarge layout.
  final ResponsiveLayoutWidgetBuilder? xLarge;

  /// Optional child widget which will be passed
  /// to the `small`, `large` and `xLarge`
  /// builders as a way to share/optimize shared layout.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
          return small(context, child);
        }
        if (constraints.maxWidth <= PhotoboothBreakpoints.medium) {
          return (medium ?? large).call(context, child);
        }
        if (constraints.maxWidth <= PhotoboothBreakpoints.large) {
          return large(context, child);
        }

        return (xLarge ?? large).call(context, child);
      },
    );
  }
}

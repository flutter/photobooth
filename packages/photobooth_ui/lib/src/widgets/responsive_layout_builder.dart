import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/src/layout/layout.dart';

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
  }) : super(key: key);

  /// [WidgetBuilder] for mobile layout.
  final WidgetBuilder mobile;

  /// [WidgetBuilder] for desktop layout.
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth <= PhotoboothBreakpoints.mobile
            ? mobile(context)
            : desktop(context);
      },
    );
  }
}

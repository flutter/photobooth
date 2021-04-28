import 'package:flutter/material.dart';

/// {@template app_persistent_tooltip}
/// Container identical to a tooltip but just displayed persistenly
/// {@endtemplate}
class AppPersistentTooltip extends StatelessWidget {
  /// {@macro app_persistent_tooltip}
  const AppPersistentTooltip({
    Key? key,
    required this.text,
  }) : super(key: key);

  /// Text to display on the tooltip
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).tooltipTheme;
    return Container(
      decoration: theme.decoration,
      padding: theme.padding,
      child: Text(
        text,
        style: theme.textStyle,
      ),
    );
  }
}

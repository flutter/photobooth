import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';

/// Responsive breakpoints of interests for Photobooth UI
enum WindowBreakpoint {
  /// Small breakpoint (RangeValues(from 0 to 1023))
  small,

  /// Large breakpoint (RangeValues(larger than 1023))
  large,
}

/// {@template margin_and_gutters_extension}
/// Margin calculations
/// {@endtemplate}
extension BuildContextExtension on BuildContext {
  /// Returns the breakpoint for the current size of the window
  WindowBreakpoint get windowBreakpoint {
    final windowType = getWindowType(this);
    if (windowType == AdaptiveWindowType.xsmall ||
        windowType == AdaptiveWindowType.small) {
      return WindowBreakpoint.small;
    }
    return WindowBreakpoint.large;
  }
}

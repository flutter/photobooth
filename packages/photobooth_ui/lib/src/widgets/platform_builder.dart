import 'package:flutter/widgets.dart';
import 'package:platform_helper/platform_helper.dart';

/// {@template platform_builder}
/// A builder for mobile and desktop platform
/// {@endtemplate}
class PlatformBuilder extends StatelessWidget {
  /// {@macro platform_builder}
  const PlatformBuilder({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

  /// [Widget] for mobile.
  final Widget mobile;

  /// [Widget] for desktop.
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return const PlatformHelper().isMobile ? mobile : desktop;
  }
}

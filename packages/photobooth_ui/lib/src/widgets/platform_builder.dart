import 'package:flutter/widgets.dart';
import 'package:platform_helper/platform_helper.dart';

/// {@template platform_builder}
/// A builder for mobile and desktop platform
/// {@endtemplate}
class PlatformBuilder extends StatelessWidget {
  /// {@macro platform_builder}
  PlatformBuilder({
    required this.mobile,
    required this.desktop,
    PlatformHelper? platformHelper,
    super.key,
  }) : _platformHelper = platformHelper ?? PlatformHelper();

  /// [Widget] for mobile.
  final Widget mobile;

  /// [Widget] for desktop.
  final Widget desktop;

  final PlatformHelper _platformHelper;

  @override
  Widget build(BuildContext context) {
    return _platformHelper.isMobile ? mobile : desktop;
  }
}

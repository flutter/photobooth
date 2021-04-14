import 'package:flutter/widgets.dart';
import 'package:platform_helper/platform_helper.dart';

/// {@template platform_builder}
/// A builder for mobile and desktop platform
/// {@endtemplate}
class PlatformBuilder extends StatelessWidget {
  /// {@macro platform_builder}
  PlatformBuilder({
    Key? key,
    required this.mobile,
    required this.desktop,
    PlatformHelper? platformHelper,
  })  : _platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

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

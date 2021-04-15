import 'package:platform_helper/platform_helper.dart';

late final _platformHelper = PlatformHelper();

/// Returns whether the current platform is running on a mobile device.
bool get isMobile => _platformHelper.isMobile;

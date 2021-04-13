import 'package:photobooth_ui/src/platform_helper/src/web_platform_helper.dart'
    if (dart.library.io) 'package:photobooth_ui/src/platform_helper/src/io_platform_helper.dart';

/// Abstract class for PlatformHelper
abstract class PlatformHelper {
  /// Returns true if it is a mobile device
  static bool get isMobile => isMobileImpl;
}

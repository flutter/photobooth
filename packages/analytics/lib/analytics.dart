/// A Flutter package which adds analytics support.
library analytics;

export 'src/analytics_io.dart' if (dart.library.html) 'src/analytics_web.dart';

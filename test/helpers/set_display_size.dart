import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const landscapeDisplaySize = Size(1920, 1080);
const portraitDisplaySize = Size(1080, 1920);

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }
}

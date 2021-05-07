import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setLandscapeDisplaySize() {
    setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
  }

  void setPortraitDisplaySize() {
    setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
  }
}

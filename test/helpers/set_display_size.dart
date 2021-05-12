import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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

  void setLandscapeDisplaySize() {
    setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
  }

  void setPortraitDisplaySize() {
    setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(PhotoboothBreakpoints.small - 1, 1000));
  }
}

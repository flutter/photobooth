import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(double size) {
    binding.window.physicalSizeTestValue = Size(size, size);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  }
}

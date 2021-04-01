import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import 'font_weights.dart';

/// Very Good Text Style Definitions
class VeryGoodTextStyle {
  /// Headline 1 Text Style

  static TextStyle get headline1 => _baseTextStyle.copyWith(
        fontSize: 56,
        fontWeight: VeryGoodFontWeight.medium,
      );

  /// Headline 2 Text Style
  static TextStyle get headline2 => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: VeryGoodFontWeight.regular,
      );

  /// Headline 3 Text Style
  static TextStyle get headline3 => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: VeryGoodFontWeight.medium,
      );

  /// Headline 4 Text Style
  static TextStyle get headline4 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: VeryGoodFontWeight.bold,
      );

  /// Headline 5 Text Style
  static TextStyle get headline5 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: VeryGoodFontWeight.medium,
      );

  /// Headline 6 Text Style
  static TextStyle get headline6 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: VeryGoodFontWeight.bold,
      );

  /// Subtitle 1 Text Style
  static TextStyle get subtitle1 => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: VeryGoodFontWeight.bold,
      );

  /// Subtitle 2 Text Style
  static TextStyle get subtitle2 => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: VeryGoodFontWeight.bold,
      );

  /// Body Text 1 Text Style
  static TextStyle get bodyText1 => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: VeryGoodFontWeight.medium,
      );

  /// Body Text 2 Text Style (the default)
  static TextStyle get bodyText2 => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: VeryGoodFontWeight.regular,
      );

  /// Caption Text Style
  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: VeryGoodFontWeight.medium,
      );

  /// Overline Text Style
  static TextStyle get overline => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: VeryGoodFontWeight.regular,
      );

  /// Button Text Style
  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: VeryGoodFontWeight.medium,
      );

  static const _baseTextStyle = TextStyle(
    fontFamily: 'RedHatDisplay',
    package: 'photobooth_ui',
    color: PhotoboothColors.black,
    fontWeight: VeryGoodFontWeight.regular,
  );
}

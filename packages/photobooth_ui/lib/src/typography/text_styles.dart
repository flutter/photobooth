import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import 'font_weights.dart';

/// Photobooth Text Style Definitions
class PhotoboothTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'photobooth_ui',
    fontFamily: 'GoogleSans',
    color: PhotoboothColors.black,
    fontWeight: PhotoboothFontWeight.regular,
  );

  /// Headline 1 Text Style

  static TextStyle get headline1 => _baseTextStyle.copyWith(
        fontSize: 56,
        fontWeight: PhotoboothFontWeight.medium,
      );

  /// Headline 2 Text Style
  static TextStyle get headline2 => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: PhotoboothFontWeight.regular,
      );

  /// Headline 3 Text Style
  static TextStyle get headline3 => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: PhotoboothFontWeight.medium,
      );

  /// Headline 4 Text Style
  static TextStyle get headline4 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: PhotoboothFontWeight.bold,
      );

  /// Headline 5 Text Style
  static TextStyle get headline5 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: PhotoboothFontWeight.medium,
      );

  /// Headline 6 Text Style
  static TextStyle get headline6 => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: PhotoboothFontWeight.bold,
      );

  /// Subtitle 1 Text Style
  static TextStyle get subtitle1 => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: PhotoboothFontWeight.bold,
      );

  /// Subtitle 2 Text Style
  static TextStyle get subtitle2 => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: PhotoboothFontWeight.bold,
      );

  /// Body Text 1 Text Style
  static TextStyle get bodyText1 => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: PhotoboothFontWeight.medium,
      );

  /// Body Text 2 Text Style (the default)
  static TextStyle get bodyText2 => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: PhotoboothFontWeight.regular,
      );

  /// Caption Text Style
  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: PhotoboothFontWeight.medium,
      );

  /// Overline Text Style
  static TextStyle get overline => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: PhotoboothFontWeight.regular,
      );

  /// Button Text Style
  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: PhotoboothFontWeight.medium,
      );
}

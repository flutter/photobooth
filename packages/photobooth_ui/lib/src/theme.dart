import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photobooth_ui/src/typography/typography.dart';

/// Namespace for the Photobooth [ThemeData].
class PhotoboothTheme {
  /// Default `ThemeData` for Photobooth UI.
  static ThemeData get themeData {
    return ThemeData(
      accentColor: PhotoboothColors.lightBlue,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme => TextTheme(
        headline1: VeryGoodTextStyle.headline1,
        headline2: VeryGoodTextStyle.headline2,
        headline3: VeryGoodTextStyle.headline3,
        headline4: VeryGoodTextStyle.headline4,
        headline5: VeryGoodTextStyle.headline5,
        headline6: VeryGoodTextStyle.headline6,
        subtitle1: VeryGoodTextStyle.subtitle1,
        subtitle2: VeryGoodTextStyle.subtitle2,
        bodyText1: VeryGoodTextStyle.bodyText1,
        bodyText2: VeryGoodTextStyle.bodyText2,
        caption: VeryGoodTextStyle.caption,
        overline: VeryGoodTextStyle.overline,
        button: VeryGoodTextStyle.button,
      );

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(color: PhotoboothColors.lightBlue);
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        textStyle: _textTheme.button,
        primary: PhotoboothColors.blueButton,
        minimumSize: const Size(208, 54),
      ),
    );
  }
}

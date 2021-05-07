import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photobooth_ui/src/typography/typography.dart';

/// Namespace for the Photobooth [ThemeData].
class PhotoboothTheme {
  /// Default `ThemeData` for Photobooth UI.
  static ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(accentColor: PhotoboothColors.blue),
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textTheme: _textTheme,
      dialogBackgroundColor: PhotoboothColors.whiteBackground,
      dialogTheme: _dialogTheme,
      tooltipTheme: _tooltipTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      dividerTheme: _dividerTheme,
    );
  }

  static TextTheme get _textTheme => TextTheme(
        headline1: PhotoboothTextStyle.headline1,
        headline2: PhotoboothTextStyle.headline2,
        headline3: PhotoboothTextStyle.headline3,
        headline4: PhotoboothTextStyle.headline4,
        headline5: PhotoboothTextStyle.headline5,
        headline6: PhotoboothTextStyle.headline6,
        subtitle1: PhotoboothTextStyle.subtitle1,
        subtitle2: PhotoboothTextStyle.subtitle2,
        bodyText1: PhotoboothTextStyle.bodyText1,
        bodyText2: PhotoboothTextStyle.bodyText2,
        caption: PhotoboothTextStyle.caption,
        overline: PhotoboothTextStyle.overline,
        button: PhotoboothTextStyle.button,
      );

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(color: PhotoboothColors.blue);
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        textStyle: _textTheme.button,
        primary: PhotoboothColors.blue,
        minimumSize: const Size(208, 54),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        side: const BorderSide(color: PhotoboothColors.white, width: 2),
        padding: const EdgeInsets.all(24),
        textStyle: _textTheme.button,
        primary: PhotoboothColors.white,
        minimumSize: const Size(208, 54),
      ),
    );
  }

  static TooltipThemeData get _tooltipTheme {
    return const TooltipThemeData(
      decoration: BoxDecoration(
        color: PhotoboothColors.charcoal,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.all(10),
      textStyle: TextStyle(color: PhotoboothColors.white),
    );
  }

  static DialogTheme get _dialogTheme {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: PhotoboothColors.whiteBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }

  static TabBarTheme get _tabBarTheme {
    return const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2.0,
          color: PhotoboothColors.blue,
        ),
      ),
      labelColor: PhotoboothColors.blue,
      unselectedLabelColor: PhotoboothColors.black25,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      space: 0,
      thickness: 1,
      color: PhotoboothColors.black25,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Namespace for the Photobooth [ThemeData].
class PhotoboothTheme {
  /// Default `ThemeData` for Photobooth UI.
  static ThemeData get themeData {
    return ThemeData(
      accentColor: PhotoboothColors.lightBlue,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
    );
  }

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
      ),
    );
  }
}

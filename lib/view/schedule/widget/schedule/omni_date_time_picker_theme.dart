import 'package:flutter/material.dart';

class OmniDateTimePickerTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2b7086),
      onPrimary: Color(0xff222E34),
      secondary: Colors.transparent,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.red,
      surface: Colors.white,
      onSurface: Colors.black,
    ),

    splashFactory: NoSplash.splashFactory,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
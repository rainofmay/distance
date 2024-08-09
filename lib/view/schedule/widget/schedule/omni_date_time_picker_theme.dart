import 'package:flutter/material.dart';

class OmniDateTimePickerTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff81CEE5),
      onPrimary: Color(0xff222E34),
      secondary: Colors.transparent,
      onSecondary: Color(0xff3C6769),
      error: Colors.redAccent,
      onError: Colors.red,
      surface: Color(0xff222E34),
      onSurface: Colors.white,
      // background: Color(0xff222E34),
      // onBackground: Colors.white,
    ),
    splashFactory: NoSplash.splashFactory,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
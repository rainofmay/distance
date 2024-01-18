import 'package:flutter/material.dart';

var theme = ThemeData(
    fontFamily: 'GmarketSansTTFMedium',
    splashColor: Colors.transparent, //클릭했을 때 애니매이션 없애는 코드
    highlightColor: Colors.transparent, //클릭했을 때 애니매이션 없애는 코드
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xff282828),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xff777777),
      selectedLabelStyle: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w100,
          height: 2.2,
          letterSpacing: 1.5,
          fontFamily: 'GmarketSansTTFMedium'),
      unselectedLabelStyle: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.normal,
          height: 2.2,
          letterSpacing: 1.5,
          fontFamily: 'GmarketSansTTFMedium'),
      selectedIconTheme: IconThemeData(size: 16),
      unselectedIconTheme: IconThemeData(size: 16),
    ));

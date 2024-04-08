import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

var theme = ThemeData(
    fontFamily: 'GmarketSansTTFMedium',
    splashColor: Colors.transparent,
    //클릭했을 때 애니매이션 없애는 코드
    highlightColor: Colors.transparent,
    //클릭했을 때 애니매이션 없애는 코드
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    textTheme: const TextTheme(
        labelSmall: TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w100,
      height: 2.2,
      letterSpacing: 1.5,
    )),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DARK,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: DARK_UNSELECTED,
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
      selectedIconTheme: IconThemeData(size: 20),
      unselectedIconTheme: IconThemeData(size: 20),
    ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent)
    )
  ),

  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent)
    )
  ),

  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    overlayColor: MaterialStateProperty.all(
      Colors.transparent,
    ),
    indicatorColor: Colors.black,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: Colors.transparent,
  )
);

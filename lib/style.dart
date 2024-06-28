import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

var theme = ThemeData(
  fontFamily: 'GmarketSansTTFMedium',
  splashColor: TRANSPARENT,
  //클릭했을 때 애니매이션 없애는 코드
  highlightColor: TRANSPARENT,
  //클릭했을 때 애니매이션 없애는 코드
  hoverColor: TRANSPARENT,
  focusColor: TRANSPARENT,
  textTheme: const TextTheme(
      labelSmall: TextStyle(
    color: Colors.black,
    fontSize: 9,
    fontWeight: FontWeight.w100,
    height: 2.2,
    letterSpacing: 1.5,
  )),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: DARK,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: PRIMARY_COLOR,
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

  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    overlayColor: WidgetStateColor.transparent,
    indicatorColor: Colors.black,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: TRANSPARENT,
  ),
  // appBarTheme: AppBarTheme(
  //   systemOverlayStyle: SystemUiOverlayStyle.dark,
  // )
);

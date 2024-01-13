import 'package:flutter/material.dart';

var theme = ThemeData(
    // sliderTheme: SliderThemeData(
    //     inactiveTickMarkColor: Colors.black,
    //     activeTickMarkColor: Colors.white,
    //     valueIndicatorColor: Colors.black,
    //     trackHeight: 12,
    //     activeTrackColor: Colors.blue,
    //     thumbColor: Colors.white,
    //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)
    // ),

    fontFamily: 'GmarketSansTTFMedium',
    splashColor: Colors.transparent, //클릭했을 때 애니매이션 없애는 코드
    highlightColor: Colors.transparent, //클릭했을 때 애니매이션 없애는 코드
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xff333F50),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xffFFC000),
      unselectedItemColor: Colors.white,
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

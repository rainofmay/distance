import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CustomBottomNavagationBar extends StatefulWidget {
  final Function setBottomIndex;
  const CustomBottomNavagationBar({super.key, required this.setBottomIndex});

  @override
  State<CustomBottomNavagationBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<CustomBottomNavagationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //bottom navagation 클릭 시 값을 받아서 함수에서 설정함, 이때 widget. 을 붙여주지 않으면 함수 인식 못 함
      widget.setBottomIndex(index);

    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap:  _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill), label: '내 방',),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_rectangle_fill), label: '그룹스터디',),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2_fill), label: '메신저'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gift_fill), label: '스토어'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
        ]);
  }
}

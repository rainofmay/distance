import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/pages/myroom.dart';
import 'package:mobile/pages/groupstudy.dart';
import 'package:mobile/pages/messenger.dart';
import 'package:mobile/pages/store.dart';
import 'package:mobile/pages/etc.dart';
import 'package:cupertino_icons/cupertino_icons.dart';


void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: mainstyle.theme));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  final List screens = [MyRoom(), GroupStudy(), Messenger(), Store(), Etc()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => setState(() => selectedIndex = index),
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_fill), label: '내 방',),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_crop_rectangle_fill), label: '그룹스터디',),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2_fill), label: '메신저'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.gift_fill), label: '스토어'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
          ]),
    );
  }
}

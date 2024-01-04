import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionIcons extends StatefulWidget {
  const OptionIcons({super.key});

  @override
  State<OptionIcons> createState() => _OptionIconsState();
}

class _OptionIconsState extends State<OptionIcons> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
// 아이콘버튼 3개를 생기게 하는 함수
      },
      icon: Icon(CupertinoIcons.cube, color: Colors.white, size: 25,  ),
    );
  }
}

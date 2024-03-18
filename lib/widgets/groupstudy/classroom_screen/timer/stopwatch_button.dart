import 'package:flutter/material.dart';

class StopWatchButton extends StatefulWidget {
  final onPressedFunction ;
  final String buttonName ;
  const StopWatchButton({super.key, required this.onPressedFunction, required this.buttonName});

  @override
  State<StopWatchButton> createState() => _StopWatchButtonState();
}

class _StopWatchButtonState extends State<StopWatchButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressedFunction,
      style: ButtonStyle(
        // backgroundColor: MaterialStateProperty.all<Color>(
        //     Colors.white), // 배경색 설정
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            // 테두리 모양 설정 (원하는 값을 입력하세요)
            side: BorderSide(
                color: Colors.grey,
                width: 1), // 테두리 선 색상 및 두께 설정
          ),
        ),
      ),
      child: Text(
        widget.buttonName, style: TextStyle(color: Colors.black),
      ),
    );
  }
}

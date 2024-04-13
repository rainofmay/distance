import 'package:flutter/material.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

Future<void> showCustomDialog(
    BuildContext context, String title, String subtitle, Widget contents) async {
  // 현재 화면 위에 보여줄 다이얼로그 생성
  await showDialog<void>(
    context: context,
    builder: (context) {
      // 빌더로 AlertDialog 위젯을 생성
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 17)),
        content:
            Column(
              children: [
                contents,
                Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
        actions: [
          OkCancelButtons(okText: '제출', cancelText: '취소', onPressed: () {}),
        ],
      );
    },
  );
}

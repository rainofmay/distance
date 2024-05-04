import 'package:flutter/material.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

Future<void> customDialog(
    BuildContext context, String title, String? subtitle, Widget contents, Widget actionWidget) async {
  // 현재 화면 위에 보여줄 다이얼로그 생성
  await showDialog<void>(
    context: context,
    builder: (context) {
      // 빌더로 AlertDialog 위젯을 생성
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 17)),
        content: subtitle == null ? contents :
            Column(
              children: [
                contents,
                Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
        actions: [
          actionWidget,
          // OkCancelButtons(okText: '확인', cancelText: '취소', onPressed: (){},),
        ],
        actionsPadding: EdgeInsets.only(top:0, bottom: 5, left: 0, right: 20),
      );
    },
  );
}

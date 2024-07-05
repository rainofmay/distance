import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

Future<void> customDialog(BuildContext context, double height, String title,
    Widget contents, Widget? actionWidget) async {
  // 현재 화면 위에 보여줄 다이얼로그 생성
  await showDialog<void>(
    context: context,
    builder: (context) {
      // 빌더로 AlertDialog 위젯을 생성
      return AlertDialog(
        backgroundColor: DARK,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        title: Text(title, style: TextStyle(color: WHITE, fontSize: 17)),
        content: SizedBox(
            height: height,
            child: contents),
        actions: actionWidget == null
            ? null
            : [
                actionWidget,
                // OkCancelButtons(okText: '확인', cancelText: '취소', onPressed: (){},),
              ],
        actionsPadding: EdgeInsets.only(top: 0, bottom: 5, left: 0, right: 20),
      );
    },
  );
}

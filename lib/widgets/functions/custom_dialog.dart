import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

Future<void> customDialog(BuildContext context, double height, String title,
    Widget contents, Widget? actionWidget) async {
  // 현재 화면 위에 보여줄 다이얼로그 생성
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: BLACK,
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
              ],
        actionsPadding: EdgeInsets.only(top: 0, bottom: 5, left: 8, right: 20),
        contentPadding: EdgeInsets.only(left: 16, top: 15),
      );
    },
  );
}

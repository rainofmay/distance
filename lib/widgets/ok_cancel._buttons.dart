import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class OkCancelButtons extends StatelessWidget {
  final String okText;
  final Color? okTextColor;
  final String? cancelText;
  final Color? cancelTextColor;
  final VoidCallback? onCancelPressed;
  final VoidCallback onPressed;

  const OkCancelButtons(
      {super.key,
      required this.okText,
      this.okTextColor = WHITE,
      this.cancelText,
      this.cancelTextColor = WHITE,
      required this.onPressed,
      this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 30,
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(cancelText ?? '', style: TextStyle(color: cancelTextColor ?? BLACK)),
            onPressed: () {
              Navigator.of(context).pop(); // 닫히는 버튼
              onCancelPressed;
            },
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              okText,
              style: TextStyle(color: okTextColor ?? BLACK),
            ),
          ),
        ],
      ),
    );
  }
}

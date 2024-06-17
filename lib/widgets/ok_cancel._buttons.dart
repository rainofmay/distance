import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class OkCancelButtons extends StatelessWidget {
  final String okText;
  final String cancelText;
  final VoidCallback? onCancelPressed;
  final VoidCallback onPressed;

  const OkCancelButtons(
      {super.key,
      required this.okText,
      required this.cancelText,
      required this.onPressed,
      this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 30,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(cancelText, style: TextStyle(color: WHITE)),
            onPressed: () {
              Navigator.of(context).pop(); // 닫히는 버튼
              onCancelPressed;
            },
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              okText,
              style: TextStyle(color: WHITE),
            ),
          ),
        ],
      ),
    );
  }
}

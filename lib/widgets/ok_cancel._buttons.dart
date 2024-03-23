import 'package:flutter/material.dart';

class OkCancelButtons extends StatelessWidget {
  final String okText;
  final String cancelText;
  final onPressed;

  const OkCancelButtons(
      {super.key,
      required this.okText,
      required this.cancelText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 30,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(cancelText, style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(); // 닫히는 버튼
            },
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              okText,
              style: TextStyle(color: Color(0xff0029F5)),
            ),
          ),
        ],
      ),
    );
  }
}

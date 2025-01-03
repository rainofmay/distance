import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class OkCancelButtons extends StatelessWidget {
  final String okText;
  final Color? okTextColor;
  final String? cancelText;
  final Color? cancelTextColor;
  final VoidCallback? onCancelPressed;
  final VoidCallback onPressed;
  final FontWeight? fontWeight;

  const OkCancelButtons(
      {super.key,
      required this.okText,
      this.okTextColor = WHITE,
      this.cancelText,
      this.cancelTextColor = WHITE,
      required this.onPressed,
      this.onCancelPressed,
      this.fontWeight,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 30,
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(cancelText ?? '', style: TextStyle(color: cancelTextColor ?? BLACK, fontWeight: fontWeight ?? FontWeight.normal)),
            onPressed: () {
              Navigator.of(context).pop(); // 닫히는 버튼
              onCancelPressed;
            },
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              okText,
              style: TextStyle(color: okTextColor ?? BLACK, fontWeight: fontWeight ?? FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Widget? contents;
  final Widget actionWidget;
  const CustomAlertDialog({super.key, required this.title, required this.width, required this.height, this.contents, required this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DARK,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      title: Text(title, style: const TextStyle(color: WHITE, fontSize: 17)),
      content: SizedBox(
          width: width,
          height: height,
          child: contents),
      actions: [
        actionWidget,
      ],
      actionsPadding: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
      contentPadding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
    );
  }
}

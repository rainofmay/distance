import 'package:flutter/material.dart';
import 'package:mobile/widgets/appBar/menu_botton.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final GestureTapCallback backFunction;
  final Color backgroundColor;
  final Color contentColor;
  final List<Widget>? actions;

  const CustomBackAppBar(
      {super.key,
      required this.appbarTitle,
      required this.backFunction,
      required this.backgroundColor,
      required this.contentColor,
      this.actions,
      });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -10,
      backgroundColor: backgroundColor,
      shape: Border(
        bottom: BorderSide(
          color: backgroundColor,
        ),
      ),
      leading: IconButton(
        onPressed: backFunction,
        icon: Icon(
          Icons.arrow_back,
          size: 16,
          color: contentColor,
        ),
      ),
      title: Text(
        appbarTitle,
        style: TextStyle(fontSize: 16, color: contentColor),
      ),
      // centerTitle: true,
      actions: actions,
    );
  }
}

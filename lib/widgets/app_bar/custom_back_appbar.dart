import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final GestureTapCallback? backFunction;
  final bool isLeading;
  final bool isCenterTitle;
  final Color backgroundColor;
  final Color contentColor;
  final List<Widget>? actions;

  const CustomBackAppBar(
      {super.key,
      required this.appbarTitle,
      this.backFunction,
        required this.isLeading,
        required this.isCenterTitle,
      required this.backgroundColor,
      required this.contentColor,
      this.actions,
      });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      backgroundColor: backgroundColor,
      centerTitle: isCenterTitle,
      shape: Border(
        bottom: BorderSide(
          color: backgroundColor,
        ),
      ),
      leading: isLeading ? IconButton(
        hoverColor: TRANSPARENT,
        splashColor: TRANSPARENT,
        highlightColor: TRANSPARENT,
        onPressed: backFunction ?? Navigator.of(context).pop,
        icon: Icon(
          Icons.arrow_back,
          size: 24,
          color: contentColor,
        ),
      ) : Container(),
      title: Text(
        appbarTitle,
        style: TextStyle(fontSize: 18, color: contentColor),
      ),
      // centerTitle: true,
      actions: actions,
    );
  }
}

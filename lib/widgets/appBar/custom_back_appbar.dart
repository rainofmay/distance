import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final GestureTapCallback backFunction;
  final double headerHeight = 55;
  final Color backgroundColor;
  final Color contentColor;
  final bool isEndDrawer;

  const CustomBackAppBar(
      {super.key,
      required this.appbarTitle,
      required this.backFunction,
      required this.backgroundColor,
      required this.contentColor,
      required this.isEndDrawer});

  @override
  Size get preferredSize => Size.fromHeight(headerHeight);

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
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: contentColor,
        ),
      ),
      title: Text(
        appbarTitle,
        style: TextStyle(fontSize: 16, color: contentColor),
      ),
      // centerTitle: true,
      actions: [
        isEndDrawer ? Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                size: 16,
                color: contentColor,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ) : Container(),
      ],
    );
  }
}

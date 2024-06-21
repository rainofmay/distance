import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final bool? isCenterTitle;
  final double? titleSpacing;
  final Widget? leadingWidget;
  final Color backgroundColor;
  final Color contentColor;
  final List<Widget>? actions;

  const CustomAppBar({super.key,
    required this.appbarTitle,
    this.isCenterTitle,
    this.titleSpacing,
    this.leadingWidget,
    required this.backgroundColor,
    required this.contentColor,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: titleSpacing,
      centerTitle: isCenterTitle,
      backgroundColor: backgroundColor,
      shape: Border(
        bottom: BorderSide(
          color: backgroundColor,
        ),
      ),
      leading: leadingWidget,
      title: Text(
        appbarTitle,
        style: TextStyle(fontSize: 18, color: contentColor),
      ),
      // centerTitle: true,
      actions: actions,
    );
  }
}

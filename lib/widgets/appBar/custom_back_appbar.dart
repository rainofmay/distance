import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final GestureTapCallback backFunction;
  final double headerHeight = 55;
  const CustomBackAppBar({super.key, required this.appbarTitle, required this.backFunction});

  @override
  Size get preferredSize => Size.fromHeight(headerHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -10,
      backgroundColor: BLACK,
      shape: Border(
        bottom: BorderSide(
          color: BLACK,
        ),
      ),
      leading: IconButton(
        onPressed: backFunction,

        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: WHITE,),
      ),
      title: Text(appbarTitle, style: TextStyle(fontSize: 16, color: WHITE),),
      // centerTitle: true,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                size: 16,
                color: WHITE,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }
}




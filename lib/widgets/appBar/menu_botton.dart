import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Color iconColor;
  const MenuButton({super.key, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(
            Icons.menu,
            size: 16,
            color: iconColor,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        );
      }
    );;
  }
}

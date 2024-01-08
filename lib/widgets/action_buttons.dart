import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color:  Color(0xff333F50),
      elevation: 4.0,
      child: IconButton(onPressed: onPressed, icon:icon),
    );
  }
}

// return BackgorundSetting(closeContainer: closeContainer);
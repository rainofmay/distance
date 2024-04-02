import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';


class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: DARK,
      elevation: 4.0,
      child: IconButton(onPressed: onPressed, icon:icon),
    );
  }
}

// return BackgorundSetting(closeContainer: closeContainer);
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class PopUpMenu extends StatelessWidget {
  final List<String> items;
  final Icon menuIcon;
  final Function(String) onItemSelected;
  PopUpMenu({super.key, required this.items, required this.menuIcon, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        color: BLACK,
        elevation: 10,
        tooltip: "",
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) {
          return [
            for (final value in items)
              _menuItem(value)
          ];
        },
          onSelected: onItemSelected,
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 120),
        splashRadius: null,
        enabled: true,
        icon: menuIcon
      ),);
  }
}

PopupMenuItem<String> _menuItem(String text) {
  return PopupMenuItem<String>(
    enabled: true,

    /// 해당 항목 선택 시 호출
    onTap: () {},

    value: text,
    height: 40,
    child: Text(
      text,
      style: TextStyle(color: WHITE),
    ),
  );
}
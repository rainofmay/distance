import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class PopUpMenu extends StatelessWidget {
  final List<String> items;
  final Icon menuIcon;
  final String scheduleId;
  final Function(BuildContext, String, String) onItemSelected;

  PopUpMenu(
      {super.key,
      required this.items,
      required this.menuIcon,
        required this.scheduleId,
      required this.onItemSelected});

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
        // LongPressed 일 때 나오는 툴팁
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) {
          return [for (final value in items) _menuItem(context, value)];
        },
        onSelected: (item) {
          onItemSelected(context, item, scheduleId);
        },
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 120),
        splashRadius: null,
        enabled: true,
        icon: menuIcon,
      ),
    );
  }
}

PopupMenuItem<String> _menuItem(BuildContext context, String text) {
  return PopupMenuItem<String>(
    enabled: true,

    onTap: () {},

    value: text,
    height: 40,
    child: Text(
      text,
      style: TextStyle(color: WHITE),
    ),
  );
}

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Map<Icon, String> drawerMenu;
  const CustomDrawer({super.key, required this.drawerMenu});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              // backgroundImage: AssetImage(''),
            ),
            accountName: Text('테스트', style: TextStyle(color: Colors.black),),
            accountEmail: Text('abc123@naver.com', style: TextStyle(color: Colors.black)),

            onDetailsPressed: () {},
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
      for (var entry in drawerMenu.entries.toList())
            ListTile(
              leading: entry.key,
              title: Text(entry.value),
              onTap: () {},
              trailing: Icon(Icons.arrow_forward_ios),
            )
        ],
      ),
    );
  }
}

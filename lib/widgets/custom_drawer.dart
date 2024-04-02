import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Map<Map<Icon, String>, dynamic> drawerMenu;
  // final GestureTapCallback drawerMenuPressed;
  final List<IconButton>? drawerUnderMenu;
  const CustomDrawer({super.key, required this.drawerMenu, this.drawerUnderMenu});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  // backgroundImage: AssetImage(''),
                  ),
              accountName: Text(
                '테스트',
                style: TextStyle(color: Colors.black),
              ),
              accountEmail:
                  Text('abc123@naver.com', style: TextStyle(color: Colors.black)),
              onDetailsPressed: () {},
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  for (var entry in drawerMenu.entries.toList())
                    for (var val in entry.key.entries.toList())
                    ListTile(
                      leading: val.key,
                      title: Text(val.value),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => entry.value));
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                    ),
                ],
              ),
            ),
            drawerUnderMenu!=null ? Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.3)))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var value in drawerUnderMenu!) value
                ],
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

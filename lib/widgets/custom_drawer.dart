import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';

class CustomDrawer extends StatelessWidget {
  final Map<Map<Icon, String>, dynamic> drawerMenu;
  final List<IconButton>? drawerUnderMenu;
  const CustomDrawer({super.key, required this.drawerMenu, this.drawerUnderMenu});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: WHITE,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  // backgroundImage: AssetImage(''),
                  ),
              accountName: Text(
                '홍규진',
                style: const TextStyle(color: BLACK),
              ),
              accountEmail:
                  Text('abc123@naver.com', style: const TextStyle(color: BLACK)),
              onDetailsPressed: () {},
              decoration: const BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
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
                      title: Text(val.value, style: TextStyle(fontSize: 15)),
                      onTap: () {
                        Get.to(() => MaterialPageRoute(builder: (c) => entry.value), preventDuplicates: true);
                        Navigator.of(context).pop();
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 15,),
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

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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

          // ListView.builder로 변환 필요
          ListTile(
            leading: Icon(Icons.home, color: Colors.grey,),
            title: Text('메뉴1'),
            onTap: () {},
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.grey,),
            title: Text('메뉴2'),
            onTap: () {},
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}

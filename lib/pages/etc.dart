import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/widgets/borderline.dart';

import '../const/colors.dart';

class Etc extends StatefulWidget {
  const Etc({super.key});

  @override
  State<Etc> createState() => _EtcState();
}

class _EtcState extends State<Etc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
          appbarTitle: '더보기',
          backgroundColor: TRANSPARENT,
          contentColor: BLACK,
          isCenterTitle: false,
          titleSpacing: 1),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: WHITE,
                      backgroundImage: AssetImage('assets/images/test.png'),
                    ),
                    const SizedBox(width: 10),
                    Text('NickName')
                  ],
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      overlayColor: TRANSPARENT,
                      shadowColor: TRANSPARENT,
                      backgroundColor: WHITE,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: BLACK),
                          borderRadius: BorderRadius.circular(20))),
                  child: Text('Log out',
                      style: TextStyle(fontSize: 10, color: BLACK)),
                )
              ],
            ),
          ),
          const BorderLine(lineHeight: 15, lineColor: TRANSPARENT),

          // 구독 프리미엄
          GestureDetector(
              child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(color: BLACK),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('「프리미엄 Distance」 이용하기',
                          style: TextStyle(color: WHITE)),
                      Text('1개월 무료 체험', style: TextStyle(color: WHITE)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward_ios),
                    color: WHITE),
              ],
            ),
          )),
          const BorderLine(lineHeight: 15, lineColor: TRANSPARENT),

          ListTile(
            onTap: () {},
            leading: Icon(Icons.notifications_none_rounded),
            title: Text('알림'),
          ),

          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),

          ListTile(
            onTap: () {},
            leading: Icon(CupertinoIcons.speaker_1),
            title: Text('업데이트 공지'),
          ),

          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),

          ListTile(
            onTap: () {},
            leading: Icon(CupertinoIcons.lock),
            title: Text('개인 정보'),
          ),

          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),

          ListTile(
            onTap: () {},
            leading: Icon(Icons.settings),
            title: Text('설정'),
          ),
        ],
      ),
    );
  }
}

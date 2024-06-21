import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/store/photo.dart';
import 'package:mobile/view/store/user_store.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

import '../../common/const/colors.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with SingleTickerProviderStateMixin {


  // final Map<Map<Icon, String>, dynamic> _drawerMenu = {
  //   {Icon(CupertinoIcons.heart_fill): 'Keep 목록'}: Container(),
  //   {Icon(CupertinoIcons.gift_fill): '내 배경함'}: Container(),
  //   {Icon(CupertinoIcons.creditcard_fill): '결제 내역'}: Container(),
  //   {Icon(CupertinoIcons.padlock_solid): '프리미엄 구독'}: Container(),
  // };
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appbarTitle: '스토어',
          isCenterTitle: true,
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [
            TextButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => UserStore()));
            }, child: const Text('My', style: TextStyle(color: WHITE, fontSize: 14)))
          ]),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              const Tab(
                height: 40,
                child: Text('배경 사진'),
              ),
              const Tab(
                height: 40,
                child: Text('배경 영상'),
              ),
              const Tab(
                height: 40,
                child: Text('음악'),
              ),
              const Tab(
                height: 40,
                child: Text('주변 소리'),
              )
            ],
            splashBorderRadius: BorderRadius.circular(0),
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  // color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: Photo(),
                ),
                Container(
                  alignment: Alignment.center,
                  child:  Container(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

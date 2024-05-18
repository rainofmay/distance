import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/pages/store_screen/user_store.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';

import '../../const/colors.dart';
import '../../widgets/borderline.dart';
import '../../widgets/custom_drawer.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // late BannerAd _bannerAd;

  final Map<Map<Icon, String>, dynamic> _drawerMenu = {
    {Icon(CupertinoIcons.heart_fill): 'Keep 목록'}: Container(),
    {Icon(CupertinoIcons.gift_fill): '내 배경함'}: Container(),
    {Icon(CupertinoIcons.creditcard_fill): '결제 내역'}: Container(),
    {Icon(CupertinoIcons.padlock_solid): '프리미엄 구독'}: Container(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    //adMobs 세팅
    // setAdMob();
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
            }, child: const Text('My', style: TextStyle(color: WHITE, fontSize: 14),))
          ]),
      // centerTitle: true,
      // endDrawer: CustomDrawer(drawerMenu: _drawerMenu),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //광고용
          // Expanded(
            // flex: 0, // Column의 나머지 공간을 차지하지 않도록 설정합니다.
            // child: SizedBox(
                // height: _bannerAd.size.height.toDouble(),
                // width: _bannerAd.size.width.toDouble(),
                // AdWidget(ad: _bannerAd),
          //       ),
          // ),
          // Text('테마1', style: TextStyle(fontSize: 20)),
          TabBar(
            tabs: [
              const Tab(
                height: 40,
                child: Text('홈'),
              ),
              const Tab(
                height: 40,
                child: Text('내 방 배경'),
              ),
              const Tab(
                height: 40,
                child: Text('음악 & 소리'),
              )
            ],
            splashBorderRadius: BorderRadius.circular(0),
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
          ),
          BorderLine(lineHeight: 10, lineColor: TRANSPARENT),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  // color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: Container(),
                ),
                Container(
                  alignment: Alignment.center,
                  child:  Container(),
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

// String get _bannerAdUnitId {
//   if (Platform.isAndroid) {
//     if (kReleaseMode) {
//       //실제 출시할 때 모드
//       return 'ca-app-pub-8938897655433496~4784306203';
//     } else {
//       //테스팅 모드
//       return 'ca-app-pub-3940256099942544/6300978111';
//     }
//   } else if (Platform.isIOS) {
//     if (kReleaseMode) {
//       //실제 출시할 때 모드
//       return 'ca-app-pub-8938897655433496/1313617445';
//     } else {
//       //테스팅 모드
//       return 'ca-app-pub-3940256099942544/2934735716';
//     }
//   } else {
//     throw UnsupportedError('Unsupported OS is detected.');
//   }
// }
//
// void setAdMob() {
//   //adMobSetting
//
//   _bannerAd = BannerAd(
//     size: AdSize.banner,
//     adUnitId: _bannerAdUnitId,
//     listener: BannerAdListener(onAdLoaded: (ad) {
//       setState(() {
//         print("광고 업로드 완료");
//       });
//     }, onAdFailedToLoad: (ad, error) {
//       print(error.message);
//     }),
//     request: AdRequest(),
//   );
//   _bannerAd.load();
// }
}

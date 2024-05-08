import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../const/colors.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    //adMobs 세팅
    setAdMob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        backgroundColor: TRANSPARENT,
        elevation: 0,
        // centerTitle: true,
        title: Text('스토어'),
        leading: Image(
          image: AssetImage(
            'assets/images/store.png',
          ),
        ),
        // 캐릭터
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //광고용
          Expanded(
            flex: 0, // Column의 나머지 공간을 차지하지 않도록 설정합니다.
            child: SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          ),
          Text('테마1', style: TextStyle(fontSize: 40)),
          Text('테마2', style: TextStyle(fontSize: 40)),
        ],
      ),
    );
  }

  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kReleaseMode) {
        //실제 출시할 때 모드
        return 'ca-app-pub-8938897655433496~4784306203';
      } else {
        //테스팅 모드
        return 'ca-app-pub-3940256099942544/6300978111';
      }
    } else if (Platform.isIOS) {
      if (kReleaseMode) {
        //실제 출시할 때 모드
        return 'ca-app-pub-8938897655433496/1313617445';
      } else {
        //테스팅 모드
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      throw UnsupportedError('Unsupported OS is detected.');
    }
  }

  void setAdMob() {
    //adMobSetting

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _bannerAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          print("광고 업로드 완료");
        });
      }, onAdFailedToLoad: (ad, error) {
        print(error.message);
      }),
      request: AdRequest(),
    );
    _bannerAd.load();
  }
}

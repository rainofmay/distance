import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/ads/adsHelper.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/theme_detail_choice_screen.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';
import 'package:mobile/widgets/custom_drawer.dart';

class BackgroundThemes extends StatefulWidget {
  BackgroundThemes({super.key});

  @override
  _BackgroundThemesState createState() => _BackgroundThemesState();
}

class _BackgroundThemesState extends State<BackgroundThemes> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  void _loadAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }


  @override
  void initState() {
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: CustomAppBar(
            appbarTitle: 'View',
            isCenterTitle: true,
            actions: [
              IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.close_rounded))
            ],
            backgroundColor: WHITE,
            contentColor: BLACK),
        drawer: CustomDrawer(
          drawerMenu: {
            {Icon(Icons.favorite_border_rounded): '찜한 목록'}: '찜한 페이지',
            {Icon(CupertinoIcons.money_dollar_circle): '구매 내역'}: '구매 내역',
          },
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isAdLoaded)
                            SizedBox(
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 10.0),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.snow),
                      const SizedBox(width: 1),
                      const Text('계절',
                          style: TextStyle(fontSize: 16, color: BLACK)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ThemeBox(
                          themeName: 'Spring',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "spring",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/spring_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Summer',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "summer",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/summer_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Fall',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "fall",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage('assets/images/themes/fall_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Winter',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "winter",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/winter_theme.jpg'),
                              fit: BoxFit.cover)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10.0),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.camera_on_rectangle, size: 18),
                      const SizedBox(width: 6),
                      const Text('공간',
                          style: TextStyle(fontSize: 16, color: BLACK)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ThemeBox(
                          themeName: 'Ocean',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "ocean",)));
                          },                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/ocean_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Sunset',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "sunset",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                              AssetImage('assets/images/themes/sunset_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Cafe',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "cafe",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage('assets/images/themes/cafe_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Camping',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "camping",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/camping_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'City',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "city",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage('assets/images/themes/city_theme.jpg'),
                              fit: BoxFit.cover)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.pets_sharp, size: 18),
                      const SizedBox(width: 5),
                      const Text('Mate',
                          style: TextStyle(fontSize: 16, color: BLACK)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ThemeBox(
                          themeName: 'Animal',
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "animal",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/animal_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Gomzy',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => ThemeDetailChoiceScreen(category: "gomzy",)));
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/gomzy_theme.jpg'),
                              fit: BoxFit.cover)),
                    ],
                  ),
                ),
                // TODO: Display a banner when ready
              ],
            ),
          ]),
        ));
  }
}

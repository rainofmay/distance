import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/pages/myroom_screen/background_themes/spring_screen.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';
import '../../../widgets/custom_drawer.dart';

class BackgroundThemes extends StatefulWidget {
  const BackgroundThemes({super.key});

  @override
  State<BackgroundThemes> createState() => _BackgroundThemesState();
}

class _BackgroundThemesState extends State<BackgroundThemes> {
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
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(color: DARK),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('「프리미엄 Distance」',
                            style: TextStyle(color: PRIMARY_COLOR)),
                        Text('1개월 무료 체험', style: TextStyle(color: WHITE)),
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
                                MaterialPageRoute(builder: (c) => SpringScreen()));
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
                          onTap: () {},
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
                          onTap: () {},
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
                          onTap: () {},
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
                          onTap: () {},
                          left: 12,
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
                          themeName: 'Camping',
                          onTap: () {},
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
                          themeName: 'Cafe',
                          onTap: () {},
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
                          themeName: 'City',
                          onTap: () {},
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage('assets/images/themes/city_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Study',
                          onTap: () {},
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image:
                                  AssetImage('assets/images/themes/study_theme.jpg'),
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
              ],
            ),
          ]),
        ));
  }
}

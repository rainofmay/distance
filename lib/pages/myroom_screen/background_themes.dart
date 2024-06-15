import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';
import '../../widgets/custom_drawer.dart';

class BackgroundThemes extends StatefulWidget {
  const BackgroundThemes({super.key});

  @override
  State<BackgroundThemes> createState() => _BackgroundThemesState();
}

class _BackgroundThemesState extends State<BackgroundThemes>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
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
        backgroundColor: WHITE,
        appBar: CustomAppBar(
            appbarTitle: 'My View',
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
        body: Column(children: [
          TabBar(
            tabs: [
              const Tab(height: 40, child: Text('사진/그림')),
              const Tab(height: 40, child: Text('영상')),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사진, 그림 Tab
                    Container(
                      width: double.infinity,
                      height: 100,
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
                      child: const Text('| 계절',
                          style: TextStyle(fontSize: 18, color: BLACK)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ThemeBox(
                              themeName: 'Spring',
                              onTap: () {},
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/spring_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/summer_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/fall_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/winter_theme.jpg'),
                                  fit: BoxFit.cover)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45, left: 10.0),
                      child: const Text('| 공간',
                          style: TextStyle(fontSize: 18, color: BLACK)),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/ocean_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/camping_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/cafe_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/city_theme.jpg'),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/study_theme.jpg'),
                                  fit: BoxFit.cover)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45, left: 10.0),
                      child: const Text('| Mate',
                          style: TextStyle(fontSize: 18, color: BLACK)),
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
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/animal_theme.jpg'),
                                  fit: BoxFit.cover)
                          ),
                          ThemeBox(
                            themeName: 'Gomzy',
                            left: 12,
                            right: 12,
                            top: 10,
                            bottom: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 영상 Tab
                Container(alignment: Alignment.center, child: Container()),
              ],
            ),
          )
        ]));
  }
}

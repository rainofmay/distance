import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/music/widget/play_list_item.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/section_title.dart';

class MusicThemesScreen extends StatefulWidget {
  const MusicThemesScreen({super.key});

  @override
  State<MusicThemesScreen> createState() => _MusicThemesScreenState();
}

class _MusicThemesScreenState extends State<MusicThemesScreen>
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
      appBar: CustomBackAppBar(
        appbarTitle: 'Music',
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
        isLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                tabs: [
                  const Tab(
                    height: 40,
                    child: Text('Music'),
                  ),
                  const Tab(
                    height: 40,
                    child: Text('Sound'),
                  ),
                ],
                splashBorderRadius: BorderRadius.circular(0),
                indicator: BoxDecoration(
                  color: TRANSPARENT,
                ),
                controller: _tabController),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      SectionTitle(onTap: () {}, title: '지금 내 플레이리스트'),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {},
                          thumbnailUrl: 'assets/images/themes/summer_theme.jpg',
                          title: '휴가철 듣는 청량한 노래',
                          instrument: 'Vocal songs',
                          numberOfsongs: 10,
                          textColor: SECONDARY),
                      const SizedBox(height: 40),
                      // Expanded(child: ListView.builder(itemBuilder: itemBuilder)),
                      //ListView.builder 로 변환해야함 !!!
                      SectionTitle(onTap: () {}, title: '전 체'),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {},
                          thumbnailUrl: 'assets/images/themes/summer_theme.jpg',
                          title: '휴가철 듣는 청량한 노래',
                          instrument: 'Vocal songs',
                          numberOfsongs: 10,
                          textColor: SECONDARY),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {},
                          thumbnailUrl: 'assets/images/nature4.jpg',
                          title: '카페 분위기 음악',
                          instrument: 'Piano, Jazz',
                          numberOfsongs: 10,
                          textColor: BLACK),
                    ],
                  ),
                  Container(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

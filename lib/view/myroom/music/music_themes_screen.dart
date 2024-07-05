import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/myroom/myroom_music_provider.dart';
import 'package:mobile/view/myroom/music/music_detail_screen.dart';
import 'package:mobile/view/myroom/music/widget/play_list_item.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/section_title.dart';

class MusicThemesScreen extends StatefulWidget {
  const MusicThemesScreen({super.key});

  @override
  State<MusicThemesScreen> createState() => _MusicThemesScreenState();
}

class _MusicThemesScreenState extends State<MusicThemesScreen> {
  final MyroomMusicViewModel musicViewModel = Get.put(MyroomMusicViewModel(provider: Get.put(MyRoomMusicProvider())));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        backFunction: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                        children: [
                          SectionTitle(onTap: () {}, title: '지금 내 플레이리스트'),
                          const SizedBox(height: 16),
                          PlayListItem(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (c) => MusicDetailScreen()));
                              },
                              thumbnailUrl: 'assets/images/themes/summer_theme.jpg',
                              title: '휴가철 듣는 청량한 노래',
                              instrument: 'Vocal songs',
                              numberOfsongs: 10,
                              textColor: BLACK),
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
                  ),
                )
          ],
        ),
      ),
    );
  }
}

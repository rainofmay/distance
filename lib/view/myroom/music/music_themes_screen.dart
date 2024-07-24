import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
import 'package:mobile/view/myroom/music/widget/play_list_item.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/section_title.dart';

class MusicThemesScreen extends StatelessWidget {
  MusicThemesScreen({super.key});

  final MusicViewModel musicViewModel = Get.put(MusicViewModel(repository: MyRoomMusicRepository(myRoomMusicProvider: MyRoomMusicProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black87,
      appBar: CustomBackAppBar(
        appbarTitle: 'Music',
        isCenterTitle: true,
        backgroundColor:  Colors.black87,
        contentColor: WHITE,
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
                  child: Obx(() => Column(
                    children: [
                      SectionTitle(onTap: () {}, title: '지금 내 플레이리스트'),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (c) => MusicDetailScreen()));
                          },
                          thumbnailUrl: musicViewModel.currentPlayList.thumbnailUrl,
                          title: musicViewModel.currentPlayList.bigTitle,
                          instrument: 'Vocal songs',
                          numberOfSongs: musicViewModel.currentPlayList.numberOfSong,
                          textColor: PRIMARY_LIGHT),
                      const SizedBox(height: 40),
                      // Expanded(child: ListView.builder(itemBuilder: itemBuilder)),
                      //ListView.builder 로 변환해야함 !!!
                      SectionTitle(onTap: () {}, title: '전 체'),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {},
                          thumbnailUrl: 'assets/images/themes/summer_theme.jpg',
                          title: '수면 유도 음악',
                          instrument: 'Vocal songs',
                          numberOfSongs: 10,
                          textColor: WHITE),
                      const SizedBox(height: 16),
                      PlayListItem(
                          onTap: () {},
                          thumbnailUrl: 'assets/images/nature4.jpg',
                          title: '카페 분위기 음악',
                          instrument: 'Piano, Jazz',
                          numberOfSongs: 10,
                          textColor: WHITE),
                    ],
                  )),
                  ),
                )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
// import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view/myroom/music/widget/play_list_item.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:mobile/widgets/section_title.dart';

class MusicThemesScreen extends StatelessWidget {
  MusicThemesScreen({super.key});

  final MusicViewModel musicViewModel = Get.put(MusicViewModel(
      repository:
      MyRoomMusicRepository(myRoomMusicProvider: MyRoomMusicProvider())));
  final MyRoomMusicRepository _repository = Get.put(
      MyRoomMusicRepository(myRoomMusicProvider: MyRoomMusicProvider()));
  //TODO- googleAds 배포 후 넣기
  // final adController = Get.put(AdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: CustomBackAppBar(
        appbarTitle: 'Music',
        isCenterTitle: true,
        backgroundColor: Colors.black87,
        contentColor: WHITE,
        isLeading: true,
        backFunction: () {
          Navigator.of(context).pop();
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 50), // Added bottom padding for ad space
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
                            thumbnailUrl:
                            musicViewModel.currentPlayList.thumbnailUrl,
                            title: musicViewModel.currentPlayList.bigTitle,
                            info: musicViewModel.currentPlayList.info,
                            numberOfSongs:
                            musicViewModel.currentPlayList.numberOfSong,
                            textColor: PRIMARY_LIGHT),
                        const SizedBox(height: 40),
                        SectionTitle(onTap: () {}, title: '전 체'),
                        const SizedBox(height: 32),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _repository.playListTheme.length,
                              itemBuilder: (context, index) {
                                CurrentPlayList item =
                                _repository.playListTheme[index];
                                return Column(
                                  children: [
                                    PlayListItem(
                                        onTap: () {
                                          musicViewModel.currentPlayList == item ? null :
                                          customDialog(
                                              context,
                                              60,
                                              '플레이리스트 추가',
                                              const Padding(
                                                padding: EdgeInsets.only(left:8.0, top:4.0),
                                                child: Text('이 음악을 내 플레이리스트로 바꿀까요?', style: TextStyle(color: WHITE)),
                                              ),
                                              OkCancelButtons(
                                                  okTextColor: PRIMARY_LIGHT,
                                                  okText: '확인', onPressed: () async {
                                                await musicViewModel.setCurrentPlayList(item);
                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();
                                              }, cancelText: '취소', onCancelPressed: () {
                                                Navigator.of(context).pop();
                                              }));
                                        },
                                        thumbnailUrl: item.thumbnailUrl,
                                        title: item.bigTitle,
                                        info: item.info,
                                        numberOfSongs: item.numberOfSong,
                                        textColor: WHITE),
                                    const SizedBox(height: 32),
                                  ],
                                );
                              }),
                        ),
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
          //TODO- googleAds 배포 후 넣기
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Obx(() {
          //     if (adController.isAdLoaded.value) {
          //       return SizedBox(
          //         height: adController.bannerAd.value!.size.height.toDouble(),
          //         child: AdWidget(ad: adController.bannerAd.value!),
          //       );
          //     } else {
          //       return const SizedBox.shrink();
          //     }
          //   }),
          // ),
        ],
      ),
    );
  }
}
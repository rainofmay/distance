import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_sound_provider.dart';
import 'package:mobile/view_model/myroom/music/store_sound_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class SoundThemesScreen extends StatefulWidget {
  const SoundThemesScreen({super.key});

  @override
  State<SoundThemesScreen> createState() => _SoundThemesScreenState();
}

class _SoundThemesScreenState extends State<SoundThemesScreen> {
  final StoreSoundViewModel storeSoundViewModel =
      Get.put(StoreSoundViewModel(provider: Get.put(MyRoomSoundProvider())));
  late final storeSoundInfoList = storeSoundViewModel.storeSoundInfoList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    storeSoundViewModel.storeSoundPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,

        appBar: CustomBackAppBar(
            appbarTitle: 'Sound',
            isCenterTitle: true,
            backgroundColor: WHITE,
            contentColor: BLACK,
            isLeading: true,
            backFunction: () => Get.back()),
        body: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ExpansionTile(
                    tilePadding: EdgeInsets.only(left: 0, right: 8),
                    childrenPadding: EdgeInsets.only(left: 8),
                    dense: true,
                    iconColor: GREY,
                    collapsedIconColor: GREY,
                    expandedAlignment: Alignment.centerLeft,
                    leading: Icon(CupertinoIcons.heart_fill,
                        color: Color(0xff800020), size: 16),
                    title: Transform.translate(
                      offset: Offset(-16, 0),
                      child: Text(
                          '내가 담은 리스트 (${storeSoundViewModel.soundInfoListOfUser.length})',
                          style: TextStyle(fontSize: 14)),
                    ),
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              storeSoundViewModel.soundInfoListOfUser.length,
                          itemBuilder: (context, index) {
                            MusicInfo musicInfo =
                                storeSoundViewModel.soundInfoListOfUser[index];
                            return Text(musicInfo.kindOfMusic);
                          }),
                    ]),
                const SizedBox(height: 16),
                BorderLine(lineHeight: 1, lineColor: GREY.withOpacity(0.1)),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text('전 체'),
                ),

                // Wrap(
                //   spacing: 8.0,
                //   runSpacing: 6.0,
                //   children: [
                //     TextButton(onPressed: , child: child)
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('미리듣기',
                          style:
                              TextStyle(fontSize: 10, color: DARK_UNSELECTED)),
                      SizedBox(width: 28),
                      Text('담기',
                          style:
                              TextStyle(fontSize: 10, color: DARK_UNSELECTED)),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: storeSoundInfoList.length,
                      itemBuilder: (context, index) {
                        MusicInfo musicInfo = storeSoundInfoList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('# ${musicInfo.kindOfMusic}'),
                              Obx(
                                () => Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          storeSoundViewModel
                                              .storeSoundPlay(index);
                                        },
                                        icon: storeSoundViewModel
                                                        .storePlayingBoolList[
                                                    index] ==
                                                false
                                            ? Icon(CupertinoIcons.speaker_slash,
                                                size: 20)
                                            : Icon(CupertinoIcons.speaker_3,
                                                color: SECONDARY, size: 20)),
                                    const SizedBox(width: 16),
                                    IconButton(
                                        onPressed: () =>
                                            _alertDialog(context, musicInfo),
                                        icon:
                                            Icon(CupertinoIcons.heart, size: 20))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            )));
  }
}

void _alertDialog(BuildContext context, MusicInfo musicInfo) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: BLACK,
          contentPadding: EdgeInsets.only(left: 8, top: 15),
          actionsPadding: EdgeInsets.only(top: 15),
          title: Text('담 기', style: TextStyle(fontSize: 15, color: WHITE)),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: const Text('내 리스트에 담으시겠습니까?',
                        style: TextStyle(fontSize: 13, color: WHITE)),
                  ),
                ],
              ),
            );
          }),
          actions: [
            OkCancelButtons(
              okText: '확인',
              okTextColor: PRIMARY_COLOR,
              onPressed: () async {
                addMySound();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              cancelText: '취소',
            )
          ],
        );
      });
}

void addMySound() {
  // 내 사운드 즐겨찾기에 추가
  // Pro는 3개 ~ 10개, 일반은 2개
}

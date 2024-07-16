import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_sound_provider.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';
import 'package:mobile/view_model/myroom/music/store_sound_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';

class SoundThemesScreen extends StatelessWidget {
  final StoreSoundViewModel storeSoundViewModel =
  Get.put(StoreSoundViewModel(provider: Get.put(MyRoomSoundProvider())));
  late final storeSoundInfoList = storeSoundViewModel.storeSoundInfoList;
  final SoundViewModel soundViewModel = Get.find<SoundViewModel>();

  SoundThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Colors.black87,
        appBar: CustomBackAppBar(
            appbarTitle: 'Sound',
            isCenterTitle: true,
            backgroundColor: Colors.black87,
            contentColor: WHITE,
            isLeading: true,
            backFunction: () => Get.back()),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Obx(() => ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.only(left: 0, right: 8),
                      childrenPadding: EdgeInsets.only(left: 8),
                      dense: true,
                      iconColor: WHITE,
                      collapsedIconColor: WHITE,
                      expandedAlignment: Alignment.centerLeft,
                      leading: Icon(CupertinoIcons.heart_fill,
                          color: PRIMARY_LIGHT, size: 16),
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: Text(
                            '내가 담은 리스트 (${soundViewModel.soundInfoList.length})',
                            style: TextStyle(fontSize: 14, color: WHITE)),
                      ),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Obx(()=> Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(soundViewModel.soundInfoList.length, (index) {
                                  MusicInfo musicInfo = soundViewModel.soundInfoList[index];
                                  return Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xff023C46), Color(0xff001824)],
                                        ),
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                            child: Text('# ${musicInfo.kindOfMusic}', style: TextStyle(color: WHITE)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ));
                            }),
                      ])),
                  const SizedBox(height: 16),
                  BorderLine(lineHeight: 1, lineColor: WHITE.withOpacity(0.2)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: const Text('전 체', style: TextStyle(color: WHITE)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('미리듣기',
                            style: TextStyle(
                                fontSize: 10, color: TRANSPARENT_WHITE)),
                        SizedBox(width: 28),
                        Text('담기',
                            style: TextStyle(
                                fontSize: 10, color: TRANSPARENT_WHITE)),
                        SizedBox(width: 4),
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: storeSoundInfoList.length,
                      itemBuilder: (context, index) {
                        MusicInfo musicInfo = storeSoundInfoList[index];  // 스토어의 MUsicInfo

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('# ${musicInfo.kindOfMusic}', style: TextStyle(color: WHITE)),
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
                                            size: 20, color: TRANSPARENT_WHITE,)
                                            : Icon(CupertinoIcons.speaker_3,
                                            color: PRIMARY_COLOR, size: 20)),
                                    const SizedBox(width: 16),
                                    IconButton(
                                        onPressed: () async {
                                          if (_containsMusicInfoById(soundViewModel.soundInfoList, musicInfo.id) == false) {
                                          await soundViewModel.addSoundToUserList(musicInfo);
                                          }
                                          else {
                                            MusicInfo newValue = findMusicInfoById(soundViewModel.soundInfoList, musicInfo.id)!;
                                            await soundViewModel.removeSoundFromUserList(newValue);
                                          }
                                        },
                                        icon: _containsMusicInfoById(soundViewModel.soundInfoList, musicInfo.id) ? Icon(CupertinoIcons.heart_fill,
                                            size: 20, color: PRIMARY_LIGHT) : Icon(CupertinoIcons.heart,
                                            size: 20, color: WHITE))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              )),
        ));
  }
}

MusicInfo? findMusicInfoById(List<MusicInfo> musicList, int targetId) {
  try {
    return musicList.firstWhere((musicInfo) => musicInfo.id == targetId);
  } on StateError {
    // 일치하는 객체가 없을 경우 null 반환
    return null;
  }
}

bool _containsMusicInfoById(List<MusicInfo> musicList, int targetId) {
  return musicList.any((musicInfo) => musicInfo.id == targetId);
}

// void _alertDialog(BuildContext context, MusicInfo musicInfo) {
//   final SoundViewModel soundViewModel = Get.find<SoundViewModel>();
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(6)),
//           ),
//           backgroundColor: BLACK,
//           contentPadding: EdgeInsets.only(left: 8, top: 15),
//           actionsPadding: EdgeInsets.only(top: 15),
//           title: Text('담 기', style: TextStyle(fontSize: 15, color: WHITE)),
//           content: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16.0),
//                         child: const Text('내 리스트에 담으시겠습니까?',
//                             style: TextStyle(fontSize: 13, color: WHITE)),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//           actions: [
//             OkCancelButtons(
//               okText: '확인',
//               okTextColor: PRIMARY_COLOR,
//               onPressed: () async {
//                 await soundViewModel.addSoundToUserList(musicInfo);
//                 if (!context.mounted) return;
//                 Navigator.of(context).pop();
//               },
//               cancelText: '취소',
//             )
//           ],
//         );
//       });
// }

void addMySound() {
  // 내 사운드 즐겨찾기에 추가
  // Pro는 3개 ~ 10개, 일반은 2개
}
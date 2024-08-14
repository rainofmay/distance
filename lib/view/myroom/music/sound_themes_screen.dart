import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/music/myroom_sound_provider.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view/myroom/music/sound_copyright.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';
import 'package:mobile/view_model/myroom/music/store_sound_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_alert_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class SoundThemesScreen extends StatelessWidget {
  final StoreSoundViewModel storeSoundViewModel =
  Get.put(StoreSoundViewModel(provider: Get.put(MyRoomSoundProvider())));

  final SoundViewModel soundViewModel = Get.find<SoundViewModel>();
  final adController = Get.put(AdController());
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
                                          colors: [const Color(0xff023C46), const Color(0xff001824)],
                                        ),
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                            child: Text('# ${musicInfo.musicName}', style: const TextStyle(color: WHITE)),
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
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('전 체', style: TextStyle(color: WHITE)),
                        IconButton(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SoundCopyright()));
                          // Get.to(SoundCopyright());
                        }, icon: const Icon(Icons.copyright, color: TRANSPARENT_WHITE, size: 19))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('듣기',
                            style: TextStyle(
                                fontSize: 10, color: TRANSPARENT_WHITE)),
                        SizedBox(width: 45),
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
                      itemCount: storeSoundViewModel.storeSoundInfoList.length,
                      itemBuilder: (context, index) {
                        MusicInfo musicInfo = storeSoundViewModel.storeSoundInfoList[index];  // 스토어의 MUsicInfo

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('# ${musicInfo.musicName}', style: TextStyle(color: WHITE)),
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
                                            ? const Icon(CupertinoIcons.speaker_slash,
                                            size: 20, color: TRANSPARENT_WHITE,)
                                            : const Icon(CupertinoIcons.speaker_3,
                                            color: PRIMARY_COLOR, size: 20)),
                                    const SizedBox(width: 16),
                                    IconButton(
                                        onPressed: () async {
                                          if (_containsMusicInfoById(soundViewModel.soundInfoList, musicInfo.id) == false) {
                                            if (soundViewModel.soundInfoList.length < 4) {
                                              await soundViewModel.addSoundToUserList(musicInfo); }
                                            else {
                                              return _cautionDialog(context);
                                            }
                                          }
                                          else {
                                            MusicInfo newValue = findMusicInfoById(soundViewModel.soundInfoList, musicInfo.id)!;
                                            await soundViewModel.removeSoundFromUserList(newValue);
                                          }
                                        },
                                        icon: _containsMusicInfoById(soundViewModel.soundInfoList, musicInfo.id) ? const Icon(CupertinoIcons.heart_fill,
                                            size: 20, color: PRIMARY_LIGHT) : const Icon(CupertinoIcons.heart,
                                            size: 20, color: WHITE))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                  if (adController.isAdLoaded.value)
                    SizedBox(
                      height: adController.bannerAd.value!.size.height
                          .toDouble(),
                      child:
                      AdWidget(ad: adController.bannerAd.value!),
                    ),
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

void _cautionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
          title: '알림',
          width: 110,
          height: 20,
          contents: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: const Text('최대 4개까지 담을 수 있습니다.',
                style: TextStyle(color: WHITE)),
          ),
          actionWidget: OkCancelButtons(
              okText: '확인',
              okTextColor: PRIMARY_LIGHT,
              onPressed: () {
                Navigator.of(context).pop();
              },
          ));
    },
  );
}
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/view/myroom/music/widget/music_volume.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class MusicSetting extends StatefulWidget {
  const MusicSetting({super.key});

  @override
  State<MusicSetting> createState() => _MusicSettingState();
}

class _MusicSettingState extends State<MusicSetting> {
  final MyroomMusicViewModel musicViewModel = Get.put(MyroomMusicViewModel());

  @override
  void initState() {
    super.initState();
    // DUMMY_DATA 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TRANSPARENT,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Music',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: WHITE),
                      ),
                      // 세부 설정
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          musicTopBar(),
                          const SizedBox(height: 20),
                          mainMusics(),
                          musicTheme(),
                          musics()
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              OkCancelButtons(
                okText: '확인',
                cancelText: '취소',
                onPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
                onCancelPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget musicTopBar() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // 양 끝에 배치
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.music_note_2,
                            size: 16, color: WHITE),
                        SizedBox(width: 8),
                        Text(
                          '음악',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.normal,
                              color: WHITE),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: WHITE)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget mainMusics() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20.0),
      child: Obx(() => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: musicViewModel.isInstrumentalMusic.value,
                        onChanged: (value) {
                          musicViewModel.toggleInstrumentalMusic();
                        },
                      ),
                      const SizedBox(width: 5),
                      Text('연주', style: TextStyle(color: WHITE)),
                    ],
                  ),
                  Text('공부할 때 듣는 피아노', style: TextStyle(color: WHITE)),
                  SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: musicViewModel.isVocalMusic.value,
                        onChanged: (value) {
                          musicViewModel.toggleVocalMusic();
                        },
                      ),
                      const SizedBox(width: 5),
                      Text('보컬', style: TextStyle(color: WHITE)),
                    ],
                  ),
                  Text('퇴근길에 듣기 좋은 팝송', style: TextStyle(color: WHITE)),
                  Icon(CupertinoIcons.infinite, color: LIGHT_WHITE, size: 16),
                ],
              )
            ],
          )),
    );
  }
  Widget musicTheme() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          Icon(Icons.volume_up, size: 16, color: WHITE),
          SizedBox(width: 8),
          Text(
            '주변 소리',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.normal, color: WHITE),
          ),
        ],
      ),
    );
  }
  Widget musics() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.27,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() {
          return Column(
            children: musicViewModel
                .DUMMY_DATA[musicViewModel.currentGroupIndex.value]
                .map((musicInfo) {
              return MusicVolume(
                playerIndex: musicInfo.playerIndex,
                kindOfMusic: musicInfo.kindOfMusic,
                musicIcon: musicInfo.musicIcon,
                musicViewModel: musicViewModel, // ViewModel을 전달
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}

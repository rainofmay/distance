import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/custom_icon_button.dart';
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
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(children: [
            Positioned.fill(
                child: SingleChildScrollView(
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
                            mainMusics(context),
                            musicTheme(),
                            musics()
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ))),
            Positioned(
              // 하단에 버튼 고정
              bottom: 0,
              left: 0,
              right: 0,
              child: OkCancelButtons(
                okText: '확인',
                cancelText: '취소',
                onPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
                onCancelPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget musicTopBar() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // 양 끝에 배치
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Row(
                children: [
                  Icon(CupertinoIcons.music_note_2, size: 20, color: WHITE),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          '음악',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: WHITE),
                        ),
                      ],
                    ),
                  ),
                  CustomIconButton(
                    icon: Icons.arrow_forward_ios,
                    size: 20,
                    color: WHITE,
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainMusics(BuildContext context) {
    // BuildContext 추가
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20.0),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 5, // 화면 높이의 1/3
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                './assets/images/jazz1.jpeg',
                fit: BoxFit.cover, // 이미지가 잘리지 않고 꽉 차도록 설정
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 아이콘 간격 균등 분배
            children: [
              CustomIconButton(
                icon: Icons.shuffle, // 셔플 아이콘
                color: Colors.white,
                onPressed: () {
                  // 셔플 버튼 기능 구현
                },
              ),
              CustomIconButton(
                icon: Icons.skip_previous, // 이전 곡 아이콘
                color: Colors.white,
                onPressed: () {
                  // 이전 곡 버튼 기능 구현
                },
              ),
              CustomIconButton(
                icon: Icons.play_arrow, // 재생 아이콘
                color: Colors.white,
                onPressed: () {
                  // 재생 버튼 기능 구현
                },
              ),
              CustomIconButton(
                icon: Icons.skip_next, // 다음 곡 아이콘
                color: Colors.white,
                onPressed: () {
                  // 다음 곡 버튼 기능 구현
                },
              ),
              CustomIconButton(
                icon: Icons.repeat_one, // 1회 반복 아이콘
                color: Colors.white,
                onPressed: () {
                  // 1회 반복 버튼 기능 구현
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget musicTheme() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.volume_up, size: 20, color: WHITE),
                SizedBox(width: 8),
                Text(
                  //바뀌어야 함
                  '주변 소리',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: WHITE),
                ),
              ],
            ),
            CustomIconButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () {},
              size: 20,
              color: WHITE,
            )
          ],
        ),
      ),
    );
  }

  Widget musics() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.23,
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

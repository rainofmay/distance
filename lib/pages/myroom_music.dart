import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/util/global_player.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_container.dart';
import 'package:mobile/widgets/music_volume.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:provider/provider.dart';

import '../util/background_provider.dart';

class MusicSetting extends StatefulWidget {
  const MusicSetting({super.key});

  @override
  State<MusicSetting> createState() => _MusicSettingState();
}

class _MusicSettingState extends State<MusicSetting> {
  bool isMusicOn = false;

  @override
  void initState() {
    super.initState();
    // DUMMY_DATA 초기화
  }

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.read<BackgroundProvider>();
    return Dialog(
      backgroundColor: TRANSPARENT,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: CustomContainer(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.73,
          backgroundColor: DARK_BACKGROUND,
          distance: 0.5,
          widget: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '음악 설정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: WHITE),
                  ),
                  // 세부 설정
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // 양 끝에 배치
                          children: [
                            const Expanded(
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.music_note_2, size: 16, color: WHITE),
                                  SizedBox(width: 8),
                                  Text(
                                    '메인 음악',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      color: WHITE
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<GlobalAudioPlayer>(
                              builder: (context, globalAudioPlayer, child) {
                                return Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: globalAudioPlayer.isAnyPlaying,
                                    activeColor: PRIMARY_COLOR,
                                    onChanged: (value) {
                                      if (globalAudioPlayer.isAnyPlaying) {
                                        globalAudioPlayer.musicPauseAll();
                                      } else {
                                        globalAudioPlayer.musicPlayAll();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Consumer<GlobalAudioPlayer>(
                        builder: (context, globalAudioPlayer, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                //배열로 교체해야함
                                IconButton(
                                  onPressed: () {
                                    globalAudioPlayer.changeGroup(0);
                                    setState(() {});
                                  },
                                  icon: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/natureimage2.jpeg'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      globalAudioPlayer.changeGroup(1);
                                      setState(() {});
                                    },
                                    icon: Image(
                                      image: AssetImage(
                                          'assets/images/cafeImage.jpeg'),
                                      width: 50,
                                      height: 50,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      globalAudioPlayer.changeGroup(2);
                                      setState(() {});
                                    },
                                    icon: Image(
                                      image: AssetImage(
                                          'assets/images/classicImage.jpeg'),
                                      width: 50,
                                      height: 50,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      globalAudioPlayer.changeGroup(3);
                                      setState(() {});
                                    },
                                    icon: Image(
                                      image:
                                      AssetImage('assets/images/musictest.png'),
                                      width: 50,
                                      height: 50,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      globalAudioPlayer.changeGroup(4);
                                      setState(() {});
                                    },
                                    icon: Image(
                                      image:
                                      AssetImage('assets/images/musictest.png'),
                                      width: 50,
                                      height: 50,
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(top: 30),
                        child: const Row(
                          children: [
                            Icon(Icons.volume_up, size: 16, color: WHITE,),
                            SizedBox(width: 8),
                            Text('음량 설정',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: WHITE
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, right: 10),
                        height: MediaQuery.of(context).size.height *
                            0.35, // 예시로 반 화면의 높이로 설정
                        child: SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Consumer<GlobalAudioPlayer>(
                            builder: (context, globalAudioPlayer, child) {
                              return Column(
                                children: globalAudioPlayer.DUMMY_DATA[
                                globalAudioPlayer.currentGroupIndex]
                                    .map((musicInfo) {
                                  return MusicVolume(
                                    playerIndex: musicInfo.playerIndex,
                                    kindOfMusic: musicInfo.kindOfMusic,
                                    musicIcon: musicInfo.musicIcon,
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  BorderLine(lineHeight: 20, lineColor: TRANSPARENT),
                  OkCancelButtons(
                      okText: 'OK',
                      cancelText: '취소',
                      onPressed: () {
                        Navigator.of(context).pop(); // 닫히는 버튼
                        //backgroundProvider.initializeVideo()
                      },
                      onCancelPressed: () {
                        Navigator.of(context).pop(); // 닫히는 버튼
                        //backgroundProvider.initializeVideo();
                      }),
                ],
              ),
            ),
          ),),
    );
  }
}

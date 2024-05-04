import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/global_player.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/music_volume.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:provider/provider.dart';

import '../util/background_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return BackdropFilter( // blur 처리
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Dialog(
        backgroundColor: Colors.white.withOpacity(0.75),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(top:15, left:15, right: 15),
          child: SingleChildScrollView( //가로모드에서 필요(없으면 오류 발생)
            child: Column(
              children: [
                Text(
                  '음악 설정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                // 세부 설정
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // 양 끝에 배치
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.music_note_2, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  '메인 음악',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer<GlobalAudioPlayer>(
                            builder: (context, globalAudioPlayer, child) {
                              return Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: globalAudioPlayer.isAnyPlaying,
                                  activeColor: Color(0xffC8D8FA),
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
                                    image:
                                    AssetImage('assets/images/cafeImage.jpeg'),
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
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 30),
                          child: const Row(
                            children: [
                              Icon(Icons.volume_up, size: 16),
                              SizedBox(width: 8),
                              Text(
                                '음량 설정',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.normal)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, right: 10),
                          height: MediaQuery.of(context).size.height *
                              0.40, // 예시로 반 화면의 높이로 설정
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
                  ],
                ),
                BorderLine(lineHeight: 15, lineColor: Colors.transparent),
                OkCancelButtons(
                    okText: '적용',
                    cancelText: '취소',
                    onPressed: () {
                      Navigator.of(context).pop(); // 닫히는 버튼
                      backgroundProvider.initializeVideo();
                    },
                    onCancelPressed: () {
                      Navigator.of(context).pop(); // 닫히는 버튼
                      backgroundProvider.initializeVideo();
                    }
                ),
              ],
            ),
          ),
      
        ),
      ),
    );
  }
}
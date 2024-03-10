import 'package:flutter/material.dart';
import 'package:mobile/util/global_player.dart';
import 'package:mobile/widgets/music_volume.dart';
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
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    if(backgroundProvider.isImage == false) {
      backgroundProvider.videoController.pause();
    }
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
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
                      Text(
                        '#메인 뮤직',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Consumer<GlobalAudioPlayer>(
                        builder: (context, globalAudioPlayer, child) {
                          return Switch(
                            value: globalAudioPlayer.isAnyPlaying,
                            onChanged: (value) {
                              if (globalAudioPlayer.isAnyPlaying) {
                                globalAudioPlayer.musicPauseAll();
                              } else {
                                globalAudioPlayer.musicPlayAll();
                              }
                            },
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
                            onPressed: () {globalAudioPlayer.changeGroup(0);
                              setState(() { });},
                            icon: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image(
                                image: AssetImage('assets/images/natureimage2.jpeg'),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {globalAudioPlayer.changeGroup(1);
                              setState(() { });},
                              icon: Image(
                                image: AssetImage('assets/images/cafeImage.jpeg'),
                                width: 50,
                                height: 50,
                              )),
                          IconButton(
                              onPressed: () {globalAudioPlayer.changeGroup(2);
                              setState(() { });},
                              icon: Image(
                                image: AssetImage('assets/images/classicImage.jpeg'),
                                width: 50,
                                height: 50,
                              )),
                          IconButton(
                              onPressed: () {globalAudioPlayer.changeGroup(3);
                              setState(() {});},
                              icon: Image(
                                image: AssetImage('assets/images/musictest.png'),
                                width: 50,
                                height: 50,
                              )),
                          IconButton(
                              onPressed: () {globalAudioPlayer.changeGroup(4);
                              setState(() { });},
                              icon: Image(
                                image: AssetImage('assets/images/musictest.png'),
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
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        '#음량 설정',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: MediaQuery.of(context).size.height *
                          0.35, // 예시로 반 화면의 높이로 설정
                      child: SingleChildScrollView(
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
                                  assetImage: musicInfo.assetImage,
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // height: 30,
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop(); // 닫히는 버튼
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Color(0xff0029F5)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // 닫히는 버튼
                              if(backgroundProvider.isImage == false) {
                                backgroundProvider.videoController.play();
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/view/myroom/music/music_themes_screen.dart';
import 'package:mobile/view/myroom/music/sound_themes_screen.dart';
import 'package:mobile/view/myroom/music/widget/circled_music_album.dart';
import 'package:mobile/view/myroom/music/widget/music_player.dart';
import 'package:mobile/view/myroom/music/widget/sector.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/view/myroom/music/widget/music_volume.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class MyroomMusicScreen extends StatefulWidget {
  const MyroomMusicScreen({super.key});

  @override
  State<MyroomMusicScreen> createState() => _MyroomMusicScreenState();
}

class _MyroomMusicScreenState extends State<MyroomMusicScreen> {
  final MyroomMusicViewModel musicViewModel = Get.put(MyroomMusicViewModel());
  late PageController pageController;

  
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    // pageController.addListener();
  }
  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TRANSPARENT,
      body: Center(
        child: GlassMorphism(
          blur: 1,
          opacity: 0.65,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Obx(() => Stack(children: [
              Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: musicViewModel.tabIndex == 0 ? 21.0 : 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: musicViewModel.tabIndex == 0 ? PRIMARY_LIGHT : GREY,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: musicViewModel.tabIndex == 0 ? 6.0 : 21.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: musicViewModel.tabIndex == 0 ? GREY : PRIMARY_LIGHT,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )),
              Positioned.fill(
                  child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        musicViewModel.changeTabIndex(value);
                      },
                      children: [
                        /* Music */
                        SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Music',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: WHITE),
                                    ),
                                  ),

                                  // Music 아래 화면
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Sector(
                                          onTap: () {
                                            // Get.to(() => MusicThemesScreen());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                        MusicThemesScreen()));
                                          },
                                          title: '몰입에 도움이 되는 음악',
                                          iconData: CupertinoIcons.music_note_2),
                                      const SizedBox(height: 20),
                                      Center(child: CircledMusicAlbum()),
                                      MusicPlayer(),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            )),

                        /* Sound */
                        SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Sound',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: WHITE),
                                    ),
                                  ),

                                  // Sound 아래 화면
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Sector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                        SoundThemesScreen()));
                                          },
                                          title: '주변 소리',
                                          iconData: CupertinoIcons.headphones),
                                      const SizedBox(height: 20),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: musicViewModel.DUMMY_DATA.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            MusicInfo musicInfo =
                                            musicViewModel.DUMMY_DATA[index];
                                            return MusicVolume(
                                              playerIndex: musicInfo.playerIndex,
                                              musicIcon: musicInfo.musicIcon,
                                              kindOfMusic: musicInfo.kindOfMusic,
                                              musicViewModel: musicViewModel,
                                            );
                                          }),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            )),
                      ])),
              Positioned(
                // 하단에 버튼 고정
                bottom: 0,
                left: 0,
                right: 0,
                child: OkCancelButtons(
                  okText: '확인',
                  cancelText: '취소',
                  onPressed: () {
                    Get.back(); // 닫히는 버튼
                  },
                  onCancelPressed: () {
                    Get.back(); // 닫히는 버튼
                  },
                ),
              ),
            ]),)
          ),
        ),
      ),
    );
  }
}

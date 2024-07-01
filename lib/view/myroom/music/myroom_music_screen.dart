import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/music/music_themes_screen.dart';
import 'package:mobile/view/myroom/music/widget/circled_music_album.dart';
import 'package:mobile/view/myroom/music/widget/music_player.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/custom_icon_button.dart';
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
  late final PageController pageController;

  bool _isFirstScreen = true;

  void _changeScreen(value) {
    setState(() {
      // value는 PageView 에서 받아온 Int 값
      if (value == 0) {
        _isFirstScreen = true;
      } else if (value == 1) {
        _isFirstScreen = false;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Stack(children: [
            Positioned(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: _isFirstScreen ? 21.0 : 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: _isFirstScreen ? PRIMARY_LIGHT : GREY,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: _isFirstScreen ? 6.0 : 21.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: _isFirstScreen ? GREY : PRIMARY_LIGHT,
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
                      _changeScreen(value);
                    },
                    children: [
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
                        // 세부 설정
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            musicTopBar(),
                            const SizedBox(height: 20),
                            Center(child: CircledMusicAlbum()),
                            MusicPlayer(),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )),
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

                        // 세부 설정
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            musicTheme(),
                            const SizedBox(height: 20),
                            sounds(),
                            // musics(),
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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicThemesScreen()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // 양 끝에 배치
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.music_note_2, size: 16, color: WHITE),
                  const SizedBox(width: 8),
                  Text(
                    '몰입에 도움이 되는 음악',
                    style: TextStyle(fontSize: 16, color: WHITE),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
              size: 16,
              color: WHITE,
            ),
          ],
        ),
      ),
    );
  }

  Widget musicTheme() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.headphones_rounded, size: 16, color: WHITE),
              SizedBox(width: 8),
              Text(
                //바뀌어야 함
                '주변 소리',
                style: TextStyle(fontSize: 16, color: WHITE),
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

Widget sounds() {
  return ListView.builder(
    shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/images/themes/sound/grassbug.jpg', width: 30, height: 35)),
                  const SizedBox(width: 16),
                  Text('풀벌레 소리 들리는 밤', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.play, color: WHITE, size: 20)),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.speaker_2, color: WHITE, size: 20)),
              ],
            ),
          ],
        );
      });
}
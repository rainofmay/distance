import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
import 'package:mobile/view/myroom/music/music_tab_screen.dart';
import 'package:mobile/view/myroom/music/sound_tab_screen.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class MyroomMusicScreen extends StatefulWidget {
  const MyroomMusicScreen({super.key});

  @override
  State<MyroomMusicScreen> createState() => _MyroomMusicScreenState();
}

class _MyroomMusicScreenState extends State<MyroomMusicScreen> {
  final MusicViewModel musicViewModel = Get.put(MusicViewModel(repository: Get.put(MyRoomMusicRepository(myRoomMusicProvider: MyRoomMusicProvider()))));
  late PageController pageController;
  
  @override
  void initState() {
    super.initState();
    musicViewModel.setInitMusicState();
    pageController = PageController(initialPage: musicViewModel.tabIndex);
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: Obx(() => Stack(children: [
              Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
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
                        duration: const Duration(milliseconds: 200),
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
                        MusicTabScreen(viewModel: musicViewModel),
                        /* Sound */
                        SoundTabScreen(),
                      ])),
              Positioned(
                // 하단에 버튼 고정
                bottom: 16,
                left: 0,
                right: 16,
                child: OkCancelButtons(
                  okText: '확 인',
                  okTextColor: PRIMARY_LIGHT,
                  onPressed: () {
                    Navigator.of(context).pop();
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

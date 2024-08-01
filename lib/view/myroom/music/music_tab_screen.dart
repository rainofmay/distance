import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view/myroom/music/music_themes_screen.dart';
import 'package:mobile/view/myroom/music/widget/circled_music_player.dart';
import 'package:mobile/view/myroom/music/widget/sector.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';

class MusicTabScreen extends StatelessWidget {
  final MusicViewModel viewModel;
  const MusicTabScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: const Text(
              'Music',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.normal, color: WHITE),
            ),
          ),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Sector(
                  onTap: () {
                      pressed() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => MusicThemesScreen()));
                      }
                      AuthHelper.navigateToLoginScreen(
                          context, pressed);
                  },
                  title: viewModel.currentPlayList.bigTitle,
                  iconData: CupertinoIcons.music_note_2),
              const SizedBox(height: 20),
              Center(child: CircledMusicPlayer(viewModel: viewModel)),
            ],
          )),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}

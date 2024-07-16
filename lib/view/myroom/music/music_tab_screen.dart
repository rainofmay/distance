import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Sector(
                  onTap: () {
                    // Get.to(() => MusicThemesScreen());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => MusicThemesScreen()));
                  },
                  title: '너에게 위로를 주는 음악',
                  iconData: CupertinoIcons.music_note_2),
              const SizedBox(height: 20),
              Center(child: CircledMusicPlayer(viewModel: viewModel)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}

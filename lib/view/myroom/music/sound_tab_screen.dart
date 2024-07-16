import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/myroom/myroom_sound_provider.dart';
import 'package:mobile/view/myroom/music/sound_themes_screen.dart';
import 'package:mobile/view/myroom/music/widget/sound_volume.dart';
import 'package:mobile/view/myroom/music/widget/sector.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';

class SoundTabScreen extends StatelessWidget {
  SoundTabScreen({super.key});

  final SoundViewModel soundViewModel =
  Get.put(SoundViewModel(provider: Get.put(MyRoomSoundProvider())));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Sound',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal, color: WHITE),
                ),
              ),

              // Sound 아래 화면
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Sector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => SoundThemesScreen()));
                      },
                      title: '주변 소리',
                      iconData: CupertinoIcons.headphones),
                  const SizedBox(height: 20),

                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: soundViewModel.soundInfoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SoundVolume(
                          playerIndex: index,
                        );
                      })
                ],
              )),
            ],
          ),
        ));
  }
}
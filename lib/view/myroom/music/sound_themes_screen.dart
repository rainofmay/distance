import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';

class SoundThemesScreen extends StatefulWidget {
  const SoundThemesScreen({super.key});

  @override
  State<SoundThemesScreen> createState() => _SoundThemesScreenState();
}

class _SoundThemesScreenState extends State<SoundThemesScreen> {
  final MyroomMusicViewModel musicViewModel = Get.put(MyroomMusicViewModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: CustomBackAppBar(
            appbarTitle: 'Sound',
            isCenterTitle: true,
            backgroundColor: WHITE,
            contentColor: BLACK,
            isLeading: true,
            backFunction: () => Get.back()),
        body: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BorderLine(lineHeight: 1, lineColor: GREY.withOpacity(0.1)),
                const SizedBox(height: 16),
                ExpansionTile(
                    tilePadding: EdgeInsets.only(left: 0, right: 8),
                    childrenPadding: EdgeInsets.only(left: 8),
                    iconColor: GREY,
                    collapsedIconColor: GREY,
                    expandedAlignment: Alignment.centerLeft,
                    title:
                        Text('내가 담은 리스트 (5)', style: TextStyle(fontSize: 14)),
                    children: [
                      Text('테스트1'),
                      Text('테스트2'),
                    ]),
                const SizedBox(height: 16),
                BorderLine(lineHeight: 1, lineColor: GREY.withOpacity(0.1)),
                const SizedBox(height: 16),
                const Text('전 체'),
                Row(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: musicViewModel.DUMMY_DATA.length,
                    itemBuilder: (context, index) {
                      MusicInfo musicInfo = musicViewModel.DUMMY_DATA[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(musicInfo.kindOfMusic),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(CupertinoIcons.play)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(CupertinoIcons.heart))
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ],
            )));
  }
}

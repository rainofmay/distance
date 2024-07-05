import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_music_provider.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_check_box.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class SoundThemesScreen extends StatefulWidget {
  const SoundThemesScreen({super.key});

  @override
  State<SoundThemesScreen> createState() => _SoundThemesScreenState();
}

class _SoundThemesScreenState extends State<SoundThemesScreen> {
  final MyroomMusicViewModel musicViewModel = Get.put(MyroomMusicViewModel(provider: Get.put(MyRoomMusicProvider())));
  bool _isReDialog = false;

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
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text('전 체'),
                ),

                // Wrap(
                //   spacing: 8.0,
                //   runSpacing: 6.0,
                //   children: [
                //     TextButton(onPressed: , child: child)
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('미리듣기',
                          style:
                              TextStyle(fontSize: 10, color: DARK_UNSELECTED)),
                      SizedBox(width: 28),
                      Text('담기',
                          style:
                              TextStyle(fontSize: 10, color: DARK_UNSELECTED)),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
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
                                    onPressed: () => _alertDialog(musicInfo),
                                    icon: Icon(CupertinoIcons.play)),
                                const SizedBox(width: 16),
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

  void _alertDialog(musicInfo) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            backgroundColor: BLACK,
            contentPadding: EdgeInsets.only(left:8, top:24),
            actionsPadding: EdgeInsets.zero,
            title: Text('미리 듣기', style: TextStyle(fontSize: 15, color: WHITE)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: const Text('10초 간 미리 듣기가 재생됩니다.',
                          style: TextStyle(fontSize: 13, color: WHITE)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isReDialog = !_isReDialog;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckBox(
                              value: _isReDialog,
                              onChanged: (value) {
                                setState(() {
                                  _isReDialog = value!;
                                });
                              },
                              activeColor: BLACK,
                              borderColor: WHITE,
                              radius: 3),
                          const Text('다시 보지 않기',
                              style: TextStyle(
                                  fontSize: 13, color: PRIMARY_COLOR)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            actions: [
              OkCancelButtons(
                okText: '확인',
                onPressed: () {
                  // 정지 아이콘으로 바뀌고
                  // 10초간 재생
                  // 다시 재생 아이콘으로
                },
                cancelText: '취소',
              )
            ],
          );
        });
  }
}

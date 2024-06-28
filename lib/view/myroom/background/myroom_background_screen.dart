import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/view/myroom/background/background_themes/background_themes.dart';
import '../../../common/const/colors.dart';
import '../../../widgets/glass_morphism.dart';
import '../../../widgets/ok_cancel._buttons.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});

  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}

class _BackgroundSettingState extends State<BackgroundSetting> {
  File? profileImg;
  final MyroomViewModel myroomViewModel = Get.put(MyroomViewModel());

  Widget _buildBackground() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Obx(() {
          return Image.asset(
            myroomViewModel.selectedItemThumbnail.value,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.56,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.26,
            fit: BoxFit.cover,
          );
        }));
  }

  Future<void> getGalleryImage() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 20); // maximum: 100
    if (image != null) {
      setState(() {
        profileImg = File(image.path);
      });
    }
  }

  Future<void> editDialog() async {
    customDialog(
        context,
        95,
        '배경 설정',
        SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 22),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context); // dialog 내리기
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => BackgroundThemes()));
              },
              child: Row(
                children: [
                  Text('테마 고르기', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                getGalleryImage();
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
              child: Row(
                children: [
                  Text('내 앨범에서 사진/영상 선택', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
          ]),
        ),
        null);
  }

  @override
  Widget build(BuildContext context) {
    final double interval = MediaQuery
        .of(context)
        .size
        .width * 0.1;

    return Center(
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.8,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.75,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'View',
                      style: TextStyle(fontSize: 17, color: WHITE),
                    ),
                    const SizedBox(height: 25),
                    _editBackground(),
                    const SizedBox(height: 40),
                    _toggleButtons(),
                  ],
                ),
              ),
              OkCancelButtons(
                onPressed: () {
                  // 현재 화면을 pop하여 이전 화면으로 이동
                  Navigator.pop(context);
                },
                onCancelPressed: () {
                  // 저장요소 취소
                  Navigator.pop(context);
                },
                okText: '저장',
                okTextColor: WHITE,
                cancelText: '취소',
                cancelTextColor: WHITE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editBackground() {
    return GestureDetector(
      onTap: () {
        editDialog();
      },
      child: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  _buildBackground(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('배경 편집', style: TextStyle(color: WHITE)),
                      Icon(
                        Icons.edit_rounded,
                        color: WHITE,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }

  Widget _toggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Schedule', style: TextStyle(color: WHITE)),
            Transform.scale(
              scale: 0.6,
              child: Obx(() =>
                  CupertinoSwitch(
                    thumbColor: WHITE,
                    value: myroomViewModel.isSimpleWindowEnabled.value,
                    activeColor: THIRD,
                    onChanged: (value) {
                      myroomViewModel.updateSimpleWindowChange(value);
                    },
                  )),
            ),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Audio', style: TextStyle(color: WHITE)),
            Transform.scale(
              scale: 0.6,
              child: Obx(() =>
                  CupertinoSwitch(
                    activeColor: THIRD,
                    value: myroomViewModel.isAudioSpectrumEnabled.value,
                    onChanged: (value) {
                      myroomViewModel.updateAudioSpectrumChange(value);
                    },
                  )),
            ),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Words', style: TextStyle(color: WHITE)),
            Transform.scale(
              scale: 0.6,
              child: Obx(() =>
                  CupertinoSwitch(
                    activeColor: PRIMARY_COLOR,
                    value: myroomViewModel.isAudioSpectrumEnabled.value,
                    onChanged: (value) {
                      // update as necessary
                      myroomViewModel.updateAudioSpectrumChange(value);
                    },
                  )),
            ),
          ])
        ],
      ),
    );
  }


}
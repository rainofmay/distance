import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/view/myroom/widget/custom_dialog.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/view/myroom/background/background_themes/background_themes.dart';
import '../../../common/const/colors.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});

  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}

class _BackgroundSettingState extends State<BackgroundSetting> {
  File? profileImg;
  final MyroomViewModel myroomViewModel = Get.put(MyroomViewModel());

  @override
  Widget build(BuildContext context) {
    return CustomDialog(title: "View", children: [
      _editBackground(),
      _toggleButtons(),
    ]);
  }


  Widget _buildBackground() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Obx(() {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                myroomViewModel.selectedItemThumbnail.value,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.56,
                fit: BoxFit.cover,
              ),
            ),
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
                      Text('배경 편집 ', style: TextStyle(color: WHITE)),
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
                    activeColor: SECONDARY,
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
              child: Obx(() => CupertinoSwitch(
                    activeColor: SECONDARY,
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
              child: Obx(() => CupertinoSwitch(
                    activeColor: SECONDARY,
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
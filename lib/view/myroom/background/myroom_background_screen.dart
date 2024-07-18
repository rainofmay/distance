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

class MyroomBackgroundScreen extends StatefulWidget {
  const MyroomBackgroundScreen({super.key});

  @override
  State<MyroomBackgroundScreen> createState() => _MyroomBackgroundScreenState();
}

class _MyroomBackgroundScreenState extends State<MyroomBackgroundScreen> {
  File? profileImg;
  final MyroomViewModel myroomViewModel = Get.put(MyroomViewModel());

  Widget _buildBackground() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Obx(() {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                myroomViewModel.selectedItemThumbnail.value,
                width: MediaQuery.of(context).size.width * 0.56,
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
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                children: [
                  _buildBackground(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.settings,
                        color: WHITE,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text('내 배경 설정 ', style: TextStyle(color: WHITE)),
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
              child: Obx(() => CupertinoSwitch(
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
                value: myroomViewModel.isBackdropWordEnabled.value,
                onChanged: (value) {
                  // update as necessary
                  myroomViewModel.updateBackdropWordChange(value);
                },
              )),
            ),
          ])
        ],
      ),
    );
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
              Positioned.fill(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'View',
                            style: TextStyle(fontSize: 18, color: WHITE),
                          ),
                          const SizedBox(height: 16),
                          _editBackground(),
                          const SizedBox(height: 40),
                          _toggleButtons(),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                // 하단에 버튼 고정
                bottom: 0,
                left: 0,
                right: 0,
                child: OkCancelButtons(
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
                ),
              ),
            ]),
          )),
    );
  }
}

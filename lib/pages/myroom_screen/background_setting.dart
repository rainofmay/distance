import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/common/custom_dialog.dart';
import 'package:provider/provider.dart';

import '../../const/colors.dart';
import '../../util/background_setting_provider.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/glass_morphism.dart';
import '../../widgets/ok_cancel._buttons.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});

  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}


class _BackgroundSettingState extends State<BackgroundSetting> {
  File? profileImg;

  Widget _buildBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: profileImg == null ? Image.asset(
        'assets/images/test.png',
        width: MediaQuery
            .of(context)
            .size
            .width * 0.55,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        fit: BoxFit.cover,
      ) : Image(image: FileImage(profileImg!)),
    );
  }

  Future<void> getGalleryImage() async {
    // 갤러리에서 사진 선택
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 20); // maximum: 100
    if (image != null) {
      setState(() {
        profileImg = File(image.path);
      });
    }}

  @override
  Widget build(BuildContext context) {
    var backgroundSettingProvider =
    Provider.of<BackgroundSettingProvider>(context);

    return Center(
      child: GlassMorphism(
        blur: 25,
        opacity: 0.42,
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.8,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'My View',
                    style: TextStyle(fontSize: 17, color: BLACK),
                  ),
                  const SizedBox(height: 25),
                  Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: _buildBackground()
                      )),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      customDialog(
                          context,
                          95,
                          '배경 설정',
                          SingleChildScrollView(
                            child: Column(children: [
                              TextButton(
                                  child: Text('테마 고르기',
                                      style: TextStyle(color: PRIMARY_COLOR)),
                                  onPressed: () {}),
                              TextButton(
                                onPressed: () {
                                  getGalleryImage();
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('내 앨범에서 사진/영상 선택',
                                    style: TextStyle(color: WHITE)),
                              ),
                            ]),
                          ),
                          null);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: BLACK,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text('배경 편집', style: TextStyle(color: BLACK)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Schedule', style: TextStyle(color: WHITE)),
                    CupertinoSwitch(
                      thumbColor: WHITE,
                      value: backgroundSettingProvider.isSimpleWindowEnabled,
                      activeColor: SECONDARY,
                      onChanged: (value) {
                        backgroundSettingProvider
                            .updateSimpleWindowEnabled(value);
                      },
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Audio', style: TextStyle(color: WHITE)),
                    CupertinoSwitch(
                      activeColor: SECONDARY,
                      value: backgroundSettingProvider.isAudioSpectrumEnabled,
                      onChanged: (value) {
                        backgroundSettingProvider
                            .updateAudioSpectrumEnabled(value);
                      },
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Words', style: TextStyle(color: WHITE)),
                    CupertinoSwitch(
                      activeColor: SECONDARY,
                      value: backgroundSettingProvider.isAudioSpectrumEnabled,
                      onChanged: (value) {
                      },
                    ),
                  ]),
                  const SizedBox(height: 10),
                  OkCancelButtons(
                    onPressed: () {
                      // 현재 화면을 pop하여 이전 화면으로 이동
                      Navigator.pop(context);
                    },
                    onCancelPressed: () {
                      // 저장요소 취소
                      Navigator.pop(context);
                    },
                    okText: '확인',
                    cancelText: '취소',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/common/custom_dialog.dart';
import 'package:mobile/pages/myroom_screen/background_themes/background_themes.dart';
import 'package:provider/provider.dart';
import '../../common/const/colors.dart';
import '../../util/background_setting_provider.dart';
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
      child: profileImg == null
          ? Image.asset(
              'assets/images/nature1.jpeg',
              width: MediaQuery.of(context).size.width * 0.56,
              height: MediaQuery.of(context).size.height * 0.26,
              fit: BoxFit.cover,
            )
          : Image(image: FileImage(profileImg!)),
    );
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
    final double interval = MediaQuery.of(context).size.width * 0.1;
    var backgroundSettingProvider =
        Provider.of<BackgroundSettingProvider>(context);

    return Center(
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'My View',
                    style: TextStyle(fontSize: 17, color: WHITE),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      editDialog();
                    },
                    child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: _buildBackground())),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      editDialog();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: WHITE,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text('배경 편집', style: TextStyle(color: WHITE)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Schedule', style: TextStyle(color: WHITE)),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              thumbColor: WHITE,
                              value: backgroundSettingProvider
                                  .isSimpleWindowEnabled,
                              activeColor: SECONDARY,
                              onChanged: (value) {
                                backgroundSettingProvider
                                    .updateSimpleWindowEnabled(value);
                              },
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Audio', style: TextStyle(color: WHITE)),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              activeColor: SECONDARY,
                              value: backgroundSettingProvider
                                  .isAudioSpectrumEnabled,
                              onChanged: (value) {
                                backgroundSettingProvider
                                    .updateAudioSpectrumEnabled(value);
                              },
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Words', style: TextStyle(color: WHITE)),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              activeColor: SECONDARY,
                              value: backgroundSettingProvider
                                  .isAudioSpectrumEnabled,
                              onChanged: (value) {},
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 20),
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

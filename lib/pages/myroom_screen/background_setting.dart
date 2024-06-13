import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    var backgroundSettingProvider =
        Provider.of<BackgroundSettingProvider>(context);

    return Center(
      child: GlassMorphism(
        blur: 6,
        opacity: 0.1,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.73,
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
                  Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/images/test.png',
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
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
                              const SizedBox(height: 15),
                              TextButton(child: Text('테마 고르기', style: TextStyle(color: LIGHT_WHITE)), onPressed: () {}),
                              const SizedBox(height: 15),
                              TextButton(child: Text('내 앨범에서 사진/영상 선택', style: TextStyle(color: LIGHT_WHITE)), onPressed: () {}),
                            ]),
                          ),
                          null);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.pencil,
                          color: LIGHT_WHITE,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text('배경 편집', style: TextStyle(color: LIGHT_WHITE)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('윈도우', style: TextStyle(color: LIGHT_WHITE)),
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
                    Text('오디오', style: TextStyle(color: LIGHT_WHITE)),
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

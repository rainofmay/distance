import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/view/myroom/background/background_themes/background_themes.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class MyroomBackgroundScreen extends StatelessWidget {
  final MyroomViewModel myroomViewModel = Get.put(MyroomViewModel());
  MyroomBackgroundScreen({super.key});


  Widget _buildBackground(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Obx(() {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: FutureBuilder<io.File>(
                future: myroomViewModel.getImageFile(myroomViewModel.selectedItemThumbnail.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return Image.file(
                      snapshot.data!,
                      width: MediaQuery.of(context).size.width * 0.56,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Center(child: Icon(Icons.error));
                      },
                    );
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Icon(Icons.error));
                  } else {
                    return Center(
                      child: CustomCircularIndicator(size: 30),
                    );
                  }
                },
              ),
            ),
          );
        }),
    );
  }

  Future<void> editDialog(BuildContext context) async {
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
                myroomViewModel.getGalleryImage();
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

  Widget _editBackground(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pressed() {
          editDialog(context);
        }
        AuthHelper.navigateToLoginScreen(
            context, pressed);
      },
      child: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                children: [
                  _buildBackground(context),
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
            Row(
              children: [
                Icon(CupertinoIcons.clock, size: 15, color: WHITE),
                const SizedBox(width: 8),
                Text('Schedule', style: TextStyle(color: WHITE)),
              ],
            ),
            Transform.scale(
              scale: 0.6,
              child: Obx(() => CupertinoSwitch(
                thumbColor: WHITE,
                value: myroomViewModel.isSimpleWindowEnabled.value,
                activeColor: PRIMARY_COLOR,
                onChanged: (value) {
                  myroomViewModel.updateSimpleWindowChange(value);
                },
              )),
            ),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Icon(Icons.text_format_rounded, size: 17, color: WHITE),
                const SizedBox(width: 8),
                Text('Words', style: TextStyle(color: WHITE)),
              ],
            ),
            Transform.scale(
              scale: 0.6,
              child: Obx(() => CupertinoSwitch(
                activeColor: PRIMARY_COLOR,
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
                          _editBackground(context),
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

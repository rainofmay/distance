import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';

import '../../common/const/colors.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  File? profileImg;

  Future<void> getGalleryImage() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 20); // maximum: 100
    if (image != null) {
      setState(() {
        profileImg = File(image.path);
      });
    }
  }

  onSavePressed() {
    // 저장 눌렀을 때 실행할 함수

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    double fieldWidth = MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        appbarTitle: '프로필 수정',
        isLeading: true,
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
        actions: [
          TextButton(
              style: TextButton.styleFrom(overlayColor: TRANSPARENT),
              onPressed: onSavePressed,
              child: Text('저장', style: TextStyle(color: BLACK)))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              getGalleryImage();
            },
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                fit: StackFit.loose,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: profileImg == null
                        ? Image.asset(
                            'assets/images/themes/gomzy_theme.jpg',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image(image: FileImage(profileImg!)),
                  ),
                  Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                          color: DARK_UNSELECTED, borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: WHITE,
                        size: 16,
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('이름'),
                        const SizedBox(width: 20),
                        CustomTextFormField(
                          fieldWidth: fieldWidth,
                          isPasswordField: false,
                          isReadOnly: false,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            var newValue = value.toString().length;
                            if (newValue > 8) {
                              return "8자 이내로 입력하세요.";
                            } else if (newValue == 0) {
                              return "이름을 입력해 주세요.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Text('소속'),
                        const SizedBox(width: 20),
                        CustomTextFormField(
                          fieldWidth: fieldWidth,
                          isPasswordField: false,
                          isReadOnly: false,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            var newValue = value.toString().length;
                            if (newValue > 20) {
                              return "20자 이내로 입력하세요.";
                            } else if (newValue == 0) {
                              return "소개를 입력해 주세요";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Text('소개'),
                        const SizedBox(width: 20),
                        CustomTextFormField(
                          fieldWidth: fieldWidth,
                          isPasswordField: false,
                          isReadOnly: false,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            var newValue = value.toString().length;
                            if (newValue > 20) {
                              return "20자 이내로 입력하세요.";
                            } else if (newValue == 0) {
                              return "소개를 입력해 주세요";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

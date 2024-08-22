import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import 'package:mobile/common/const/colors.dart';

class ProfileEdit extends StatelessWidget {
  final MateViewModel viewModel = Get.find<MateViewModel>();
  final UserProvider userProvider = UserProvider();

  ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        appbarTitle: '프로필 편집',
        isLeading: true,
        isCenterTitle: true,
        backFunction: () async {
          viewModel.onSavePressed();
        },
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            profileImgChoose(context),
            const SizedBox(height: 50),
            nameAndIntroduce(context),
            const SizedBox(height: 50),
            buildSettingsToggle(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget profileImgChoose(BuildContext context) {
    return GestureDetector(onTap: () async {
      final profileUrl;
      profileUrl = await userProvider.editProfileImage(context); // db에 새로운 url 저장
      if (profileUrl != null) {
        await viewModel.updateProfileImageUrl(profileUrl);
        await viewModel.updateMyProfile();
      }
    }, child: Obx(
          () {
        return Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            fit: StackFit.loose,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: viewModel.localProfileImage.value != null
                    ? Image.file(
                  viewModel.localProfileImage.value!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
                    : viewModel.profileImageUrl.value == null
                    ? Image.asset(
                  'assets/images/themes/gomzy_theme.jpg',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
                    : CachedNetworkImage(
                  key: ValueKey(viewModel.profileImageUrl.value),
                  imageUrl: viewModel.profileImageUrl.value,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/themes/gomzy_theme.jpg',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                      color: DARK_UNSELECTED,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: WHITE,
                    size: 16,
                  ))
            ],
          ),
        );
      },
    ));
  }

  Widget nameAndIntroduce(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.65;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        nameEdittor(fieldWidth),
        const SizedBox(height: 32),
        introductionEdittor(fieldWidth),
        const SizedBox(height: 32),
        statusEdittor(fieldWidth)
      ],
    );
  }

  Widget nameEdittor(final fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('이름'),
        const SizedBox(width: 20),
        Obx(() => CustomTextFormField(
          controller: viewModel.nameController,
          fieldWidth: fieldWidth,
          isPasswordField: false,
          isReadOnly: false,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          maxLength: 8,
          errorText: viewModel.nameError.value,
          hasError: viewModel.nameError.isNotEmpty,
          onChanged: (value) {
            viewModel.validateName(value);
          },
        )),
      ],
    );
  }

  Widget introductionEdittor(final fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('소개'),
        const SizedBox(width: 20),
        Obx(() => CustomTextFormField(
          controller: viewModel.introduceController,
          fieldWidth: fieldWidth,
          isPasswordField: false,
          isReadOnly: false,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          maxLength: 15,
          hasError: viewModel.introductionError.isNotEmpty,
          errorText: viewModel.introductionError.value,
          onChanged: (value) {
            viewModel.validateIntroduction(value);
          },
        )),
      ],
    );
  }

  Widget statusEdittor(final fieldWidth) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              child: Text('상태'),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: fieldWidth,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewModel.setEmojiShowing(!viewModel.emojiShowing);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          viewModel
                              .userCurrentActivityEmoji.value.isNotEmpty
                              ? viewModel.userCurrentActivityEmoji.value
                              : '😀',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: viewModel.statusController,
                      fieldWidth: fieldWidth - 50,
                      isPasswordField: false,
                      isReadOnly: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      hasError: viewModel.statusError.isNotEmpty,
                      errorText: viewModel.statusError.value,
                      onChanged: (value) {
                        viewModel.validateStatus(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (viewModel.emojiShowing)
          Container(
            height: 250,
            margin: EdgeInsets.only(left: 70, top: 10),
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                viewModel.updateCurrentActivityEmoji(emoji.emoji);
                viewModel.setEmojiShowing(false);
              },
              textEditingController: viewModel.emojiController,
              config: Config(
                swapCategoryAndBottomBar: true,
                emojiViewConfig: EmojiViewConfig(
                    recentsLimit: 10,
                    replaceEmojiOnLimitExceed: true,
                    noRecents: const Text('최근 사용하신 이모티콘이 없습니다.',
                        style:
                        TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center)),
                categoryViewConfig: const CategoryViewConfig(
                  initCategory: Category.RECENT,
                  indicatorColor: PRIMARY_COLOR,
                  iconColorSelected: PRIMARY_COLOR,
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                    showSearchViewButton: false,
                    showBackspaceButton: false),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
      ],
    ));
  }

  Widget buildSettingsToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('Today Schedule 공개'),
          const SizedBox(width: 30),
          Obx(() =>
          CupertinoSwitch(
            thumbColor: WHITE,
            activeColor: PRIMARY_COLOR,
            value: viewModel.isScheduleOpen.value,
            //Color(0xffC8D8FA)
            onChanged: (bool value) {
              viewModel.isScheduleOpen.value = value;
            },
          )),
        ],
      ),
    );
  }
}
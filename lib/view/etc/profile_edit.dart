import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import 'package:mobile/common/const/colors.dart';

class ProfileEdit extends StatefulWidget {
  final MateViewModel viewModel =
      Get.find<MateViewModel>(); // Get the ViewModel instance
  final UserProvider userProvider = UserProvider();

  late final TextEditingController _nameController;

  late final TextEditingController _introduceController;

  ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  File? profileImg;
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _emojiShowing = false;

  @override
  void initState() {
    super.initState();
    widget._nameController =
        TextEditingController(text: widget.viewModel.name.value);
    widget._introduceController =
        TextEditingController(text: widget.viewModel.introduction.value);
    _statusController.text = widget.viewModel.userCurrentActivityText.value;
    _emojiController.text = widget.viewModel.userCurrentActivityEmoji.value;
  }

  @override
  void dispose() {
    _statusController.dispose();
    _emojiController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onSavePressed() {
    widget.viewModel.updateName(widget._nameController.text);
    widget.viewModel.updateIntroduction(widget._introduceController.text);
    widget.viewModel
        .onTapCurrentActivity(_emojiController.text, _statusController.text);

    widget.userProvider.editName(widget._nameController.text);
    widget.userProvider.editIntroduction(widget._introduceController.text);
    widget.userProvider.editStatusEmoji(_emojiController.text);
    widget.userProvider.editStatusText(_statusController.text);
    widget.userProvider.updateUserSettings(widget.viewModel.isWordOpen.value,
        widget.viewModel.isScheduleOpen.value);

    // 저장 완료 메시지 표시
    // CustomSnackbar.show(title: '프로필 저장', message: '프로필이 저장되었습니다.');

    // 저장 후 이전 화면으로 돌아가기
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        appbarTitle: '프로필 편집',
        isLeading: true,
        isCenterTitle: true,
        backFunction: () => onSavePressed(),
        backgroundColor: Colors.white,
        contentColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            profileImgChoose(context),
            const SizedBox(height: 50),
            nameAndIntroduce(),
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
      profileUrl = await widget.userProvider.editProfileImage(context);
      if (profileUrl != null) {
        await widget.viewModel.updateProfileImageUrl(profileUrl);
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
                child: widget.viewModel.profileImageUrl.value == null
                    ? Image.asset(
                        'assets/images/themes/gomzy_theme.jpg',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : CachedNetworkImage(
                        // CachedNetworkImage 사용
                        imageUrl: widget.viewModel.profileImageUrl.value,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) =>
                            CustomCircularIndicator(size: 30.0),
                        // 로딩 표시
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/themes/gomzy_theme.jpg',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ), // 에러 시 기본 이미지
                      ),
              ),
              Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                      color: DARK_UNSELECTED,
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
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

  Widget nameAndIntroduce() {
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
        CustomTextFormField(
          controller: widget._nameController,
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
    );
  }

  Widget introductionEdittor(final fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('소개'),
        const SizedBox(width: 20),
        CustomTextFormField(
          controller: widget._introduceController,
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
    );
  }

  Widget statusEdittor(final fieldWidth) {
    return Column(
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
                      setState(() {
                        _emojiShowing = !_emojiShowing;
                      });
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
                          _emojiController.text.isNotEmpty
                              ? _emojiController.text
                              : '😀',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _statusController,
                      fieldWidth: fieldWidth - 50,
                      isPasswordField: false,
                      isReadOnly: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        var newValue = value.toString().length;
                        if (newValue > 20) {
                          return "20자 이내로 입력하세요.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_emojiShowing)
          Container(
            height: 250,
            margin: EdgeInsets.only(left: 70, top: 10),
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _emojiController.text = emoji.emoji;
                  _emojiShowing = false;
                });
              },
              textEditingController: _emojiController,
              config: Config(
                swapCategoryAndBottomBar: true,
                emojiViewConfig: EmojiViewConfig(
                    recentsLimit: 10,
                    replaceEmojiOnLimitExceed: true,
                  noRecents: const Text('최근 사용하신 이모티콘이 없습니다.', style: TextStyle(fontSize: 20, color: Colors.black26), textAlign: TextAlign.center)
                ),
                categoryViewConfig: const CategoryViewConfig(
                    initCategory: Category.RECENT,
                    indicatorColor: PRIMARY_COLOR,
                  iconColorSelected : PRIMARY_COLOR,
                ),
                bottomActionBarConfig:
                    const BottomActionBarConfig(showSearchViewButton: false, showBackspaceButton:false),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildSettingsToggle() {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Schedule 공개'),
          value: widget.viewModel.isScheduleOpen.value,
          onChanged: (bool value) {
            setState(() {
              widget.viewModel.isScheduleOpen.value =
                  !widget.viewModel.isScheduleOpen.value;
            });
          },
        ),
      ],
    );
  }
}

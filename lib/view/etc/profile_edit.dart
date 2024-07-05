import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/util/responsiveStyle.dart';
import 'package:mobile/view/mate/widget/status_manage_online.dart';
import 'package:mobile/view/mate/widget/status_manage_schedulling.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';

import '../../common/const/colors.dart';

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

  @override
  void initState() {
    // TODO: implement initState

    widget._nameController =
        TextEditingController(text: widget.viewModel.name.value);
    widget._introduceController =
        TextEditingController(text: widget.viewModel.introduction.value);

    super.initState();
  }

  onSavePressed() {
    // 저장 눌렀을 때 실행할 함수
    widget.viewModel.updateName(widget._nameController.text);
    widget.viewModel.updateIntroduction(widget._introduceController.text);
    widget.userProvider.editName(widget._nameController.text);
    widget.userProvider.editIntroduction(widget._introduceController.text);
    widget.userProvider
        .editStatusEmoji(widget.viewModel.userCurrentActivityEmoji.value);
    widget.userProvider
        .editStatusText(widget.viewModel.userCurrentActivityText.value);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            profileImgChoose(context),
            const SizedBox(height: 50),
            nameAndIntroduce(),
            const SizedBox(height: 50),
            statusSelect()
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
                            CircularProgressIndicator(),
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
        const SizedBox(height: 20),
        introductionEdittor(fieldWidth),
      ],
    );
  }

  Widget nameEdittor(final fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('이름'),
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
        Text('소개'),
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

  Widget statusSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '상태 관리',
          style: TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () => {
                    showDialog(
                      barrierColor: TRANSPARENT,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return StatusManageOnline();
                      },
                    )
                  },
                  child: statusOnlineWidget(),
                ),
              ),
              const Divider(
                // Divider 추가
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              GestureDetector(
                onTap: () => {
                  showDialog(
                    barrierColor: TRANSPARENT,
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatusManageSchedulling();
                    },
                  )
                },
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: statusScheduleWidget()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget statusOnlineWidget() {
    return Obx(() => Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
              radius: 15,
              backgroundColor:
                  getStatusColor(widget.viewModel.isUserOnline.value)),
          const SizedBox(
            width: 40,
          ),
          Text("${widget.viewModel.isUserOnline.value}")
        ]));
  }

  Widget statusScheduleWidget() {
    return Obx(() => Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            widget.viewModel.userCurrentActivityEmoji.value.isNotEmpty
                ? widget.viewModel.userCurrentActivityEmoji.value
                : "⊕",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 40),
          Text(
              widget.viewModel.userCurrentActivityText.value.isNotEmpty
                  ? widget.viewModel.userCurrentActivityText.value
                  : "사용자 상태 지정",
              style: TextStyle(fontSize: 16)),
        ]));
  }
}

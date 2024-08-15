import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_alert_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class ThemeDetailChoiceScreen extends StatelessWidget {
  final String category;
  final viewModel = Get.put(MyroomViewModel());

  ThemeDetailChoiceScreen({super.key, required this.category});

  String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        appbarTitle: capitalize(category),
        isLeading: true,
        backFunction: () => Navigator.of(context).pop(),
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
        actions: [
          IconButton(
              onPressed: () {
                _exitDialog(context);
              },
              icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: Obx(() => gridContents(viewModel.themeContents)),
    );
  }

  void _exitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: '닫기',
            width: 120,
            height: 30,
            contents: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Text('배경 설정을 완전히 나가시겠어요?',
                  style: TextStyle(color: WHITE)),
            ),
            actionWidget: OkCancelButtons(
                okText: '확인',
                okTextColor: PRIMARY_LIGHT,
                cancelText: '취소',
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/"));
                },
                onCancelPressed: () {
                  Navigator.of(context).pop();
                }
            ));
      },
    );
  }
}

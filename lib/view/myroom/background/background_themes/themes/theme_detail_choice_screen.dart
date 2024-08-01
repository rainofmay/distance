import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

class ThemeDetailChoiceScreen extends StatelessWidget {
  final String category;
  final viewModel = Get.put(MyroomViewModel());
  ThemeDetailChoiceScreen({super.key, required this.category});
  String capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: capitalize(category),
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Obx(() => gridContents(viewModel.themeContents)),
    );
  }
}

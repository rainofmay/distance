import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/tab_bar_view.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/topper_tab_bar.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

class ThemeDetailChoiceScreen extends StatefulWidget {
  final String category;

  ThemeDetailChoiceScreen({super.key, required this.category});

  @override
  State<ThemeDetailChoiceScreen> createState() => _ThemeDetailChoiceScreen();
}

class _ThemeDetailChoiceScreen extends State<ThemeDetailChoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final viewModel =
      Get.put(MyroomViewModel()); // Get.find -> Get.put 변경 (init 안하면 찾을수 없으니까)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    viewModel.setTheme(widget.category);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: widget.category,
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: FutureBuilder(
        future: viewModel.setTheme(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator()); // 로딩 중
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 에러 처리
          } else {
            return Column(
              children: [
                const SizedBox(height: 10),
                topperTabBar(_tabController),
                Obx(() {
                  viewModel.themePictures.refresh(); // 변경 알림
                  viewModel.themeVideos.refresh(); // 변경 알림
                  return tabBarView(
                      _tabController,
                      gridPictures(viewModel.themePictures),
                      gridVideos(viewModel.themeVideos));
                }),
              ],
            );
          }
        },
      ),
    );
  }
}

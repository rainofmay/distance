import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/theme_detail_choice_screen.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';

class BackgroundThemes extends StatelessWidget {
  BackgroundThemes({Key? key}) : super(key: key);

  final viewModel = Get.put(MyroomViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: 'View',
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: SafeArea(
        bottom: false, // 하단 SafeArea를 비활성화하여 bottomNavigationBar와 겹치지 않도록 함
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThemeSection('계절', CupertinoIcons.snow, [
                _buildThemeBox('Spring', 'spring'),
                _buildThemeBox('Summer', 'summer'),
                _buildThemeBox('Fall', 'fall'),
                _buildThemeBox('Winter', 'winter'),
              ]),
              _buildThemeSection('공간', CupertinoIcons.camera_on_rectangle, [
                _buildThemeBox('Ocean', 'ocean'),
                _buildThemeBox('Sunset', 'sunset'),
                _buildThemeBox('Cafe', 'cafe'),
                _buildThemeBox('Camping', 'camping'),
                _buildThemeBox('City', 'city'),
              ]),
              _buildThemeSection('Mate', Icons.pets_sharp, [
                _buildThemeBox('Pets', 'animal'),
                _buildThemeBox('Gomzy', 'gomzy'),
              ]),
              SizedBox(height: 100), // 하단 여백 추가
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCopyrightSection(),
    );
  }

  Widget _buildThemeSection(String title, IconData icon, List<Widget> themes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, left: 10.0, bottom: 10),
          child: Row(
            children: [
              Icon(icon, size: 18),
              SizedBox(width: 5),
              Text(title, style: TextStyle(fontSize: 16, color: BLACK)),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: themes),
        ),
      ],
    );
  }

  Widget _buildThemeBox(String themeName, String category) {
    return ThemeBox(
      themeName: themeName,
      onTap: () async {
        await viewModel.setCurrentTheme(category);
        Get.to(() => ThemeDetailChoiceScreen(category: category),
            preventDuplicates: true);
      },
      left: 12,
      right: 12,
      top: 10,
      bottom: 10,
      decorationImage: DecorationImage(
        colorFilter: ColorFilter.mode(BLACK.withOpacity(0.4), BlendMode.srcOver),
        image: AssetImage('assets/images/themes/${category}_theme.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCopyrightSection() {
    return Container(
      color: DARK_BACKGROUND,
      child: SafeArea(
        top: false,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Copyright 2024, (Distance) All rights reserved.',
                style: TextStyle(color: TRANSPARENT_WHITE, fontSize: 11),
              ),
              SizedBox(height: 16),
              Text(
                '모든 사진의 저작권은 Distance에 있으며, 허가 없이 무료 또는 상업적 이용, 재배포 등을 금지합니다.',
                style: TextStyle(color: TRANSPARENT_WHITE, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
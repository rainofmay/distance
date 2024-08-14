import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/theme_detail_choice_screen.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';

class BackgroundThemes extends StatelessWidget {
  BackgroundThemes({super.key});

  final viewModel = Get.put(MyroomViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: CustomAppBar(
            appbarTitle: 'View',
            isCenterTitle: true,
            backgroundColor: WHITE,
            contentColor: BLACK),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32, left: 10.0),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.snow),
                          const SizedBox(width: 1),
                          const Text('계절',
                              style: TextStyle(fontSize: 16, color: BLACK)),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ThemeBox(
                              themeName: 'Spring',
                              onTap: () async {
                                await viewModel.setCurrentTheme('spring');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'spring'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/spring_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Summer',
                              onTap: () async {
                                await viewModel.setCurrentTheme('summer');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'summer'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/summer_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Fall',
                              onTap: () async {
                                await viewModel.setCurrentTheme('fall');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'fall'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/fall_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Winter',
                              onTap: () async {
                                await viewModel.setCurrentTheme('winter');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'winter'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/winter_theme.jpg'),
                                  fit: BoxFit.cover)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10.0),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.camera_on_rectangle, size: 18),
                          const SizedBox(width: 6),
                          const Text('공간',
                              style: TextStyle(fontSize: 16, color: BLACK)),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ThemeBox(
                              themeName: 'Ocean',
                              onTap: () async {
                                await viewModel.setCurrentTheme('ocean');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'ocean'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/ocean_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Sunset',
                              onTap: () async {
                                await viewModel.setCurrentTheme('sunset');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'sunset'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/sunset_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Cafe',
                              onTap: () async {
                                await viewModel.setCurrentTheme('cafe');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'cafe'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/cafe_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Camping',
                              onTap: () async {
                                await viewModel.setCurrentTheme('camping');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'camping'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/camping_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'City',
                              onTap: () async {
                                await viewModel.setCurrentTheme('city');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'city'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/city_theme.jpg'),
                                  fit: BoxFit.cover)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.pets_sharp, size: 18),
                          const SizedBox(width: 5),
                          const Text('Mate',
                              style: TextStyle(fontSize: 16, color: BLACK)),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ThemeBox(
                              themeName: 'Pets',
                              onTap: () async {
                                await viewModel.setCurrentTheme('animal');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'animal'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/animal_theme.jpg'),
                                  fit: BoxFit.cover)),
                          ThemeBox(
                              themeName: 'Gomzy',
                              onTap: () async {
                                await viewModel.setCurrentTheme('gomzy');
                                Get.to(
                                    () => ThemeDetailChoiceScreen(
                                        category: 'gomzy'),
                                    preventDuplicates: true);
                              },
                              left: 12,
                              right: 12,
                              top: 10,
                              bottom: 10,
                              decorationImage: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      BLACK.withOpacity(0.4),
                                      BlendMode.srcOver),
                                  image: AssetImage(
                                      'assets/images/themes/gomzy_theme.jpg'),
                                  fit: BoxFit.cover)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              Container(
                color: DARK_BACKGROUND,
                height: 95,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon(Icons.copyright, color: PRIMARY_COLOR, size: 20),
                      Text('Copyright 2024, (Distance) All right reserved.',
                          style:
                              TextStyle(color: TRANSPARENT_WHITE, fontSize: 11)),
                      const SizedBox(height: 16),
                      Text(
                          '모든 사진의 저작권은 Distance에 있으며, 허가 없이 무료 또는 상업적 이용, 재배포 등을 금지합니다.',
                          style:
                              TextStyle(color: TRANSPARENT_WHITE, fontSize: 10)),
                    ],
                  ),
                ),
              )
            ]));
  }
}

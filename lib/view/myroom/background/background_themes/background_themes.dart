import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/theme_detail_choice_screen.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/theme_box.dart';
import 'package:mobile/widgets/custom_drawer.dart';

class BackgroundThemes extends StatelessWidget {
  BackgroundThemes({super.key});
  final viewModel = Get.put(MyroomViewModel());
  final adController = Get.put(AdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: CustomAppBar(
            appbarTitle: 'View',
            isCenterTitle: true,
            actions: [
              IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.close_rounded))
            ],
            backgroundColor: WHITE,
            contentColor: BLACK),
        drawer: CustomDrawer(
          drawerMenu: {
            {Icon(Icons.favorite_border_rounded): '찜한 목록'}: '찜한 페이지',
            {Icon(CupertinoIcons.money_dollar_circle): '구매 내역'}: '구매 내역',
          },
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (adController.isAdLoaded.value)
                              SizedBox(
                                height: adController.bannerAd.value!.size.height
                                    .toDouble(),
                                child:
                                    AdWidget(ad: adController.bannerAd.value!),
                              ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 10.0),
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
                            Get.to(() => ThemeDetailChoiceScreen(category: 'spring'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/spring_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Summer',
                          onTap: () async {
                            await viewModel.setCurrentTheme('summer');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'summer'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/summer_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Fall',
                          onTap: () async {
                            await viewModel.setCurrentTheme('fall');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'fall'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/fall_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Winter',
                          onTap: () async {
                            await viewModel.setCurrentTheme('winter');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'winter'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
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
                            Get.to(() => ThemeDetailChoiceScreen(category: 'ocean'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/ocean_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Sunset',
                          onTap: () async {
                            await viewModel.setCurrentTheme('sunset');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'sunset'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/sunset_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Cafe',
                          onTap: () async {
                            await viewModel.setCurrentTheme('cafe');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'cafe'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/cafe_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Camping',
                          onTap: () async {
                            await viewModel.setCurrentTheme('camping');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'camping'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/camping_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'City',
                          onTap: () async {
                            await viewModel.setCurrentTheme('city');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'city'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
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
                            Get.to(() => ThemeDetailChoiceScreen(category: 'animal'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/animal_theme.jpg'),
                              fit: BoxFit.cover)),
                      ThemeBox(
                          themeName: 'Gomzy',
                          onTap: () async {
                            await viewModel.setCurrentTheme('gomzy');
                            Get.to(() => ThemeDetailChoiceScreen(category: 'gomzy'), preventDuplicates: true);
                          },
                          left: 12,
                          right: 12,
                          top: 10,
                          bottom: 10,
                          decorationImage: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  BLACK.withOpacity(0.4), BlendMode.srcOver),
                              image: AssetImage(
                                  'assets/images/themes/gomzy_theme.jpg'),
                              fit: BoxFit.cover)),
                    ],
                  ),
                ),
                // TODO: Display a banner when ready
              ],
            ),
          ]),
        ));
  }
}

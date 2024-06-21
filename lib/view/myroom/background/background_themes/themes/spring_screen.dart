import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/themeItem.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/tapbarView.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/topTabar.dart';

class SpringScreen extends StatefulWidget {
  const SpringScreen({super.key});

  @override
  State<SpringScreen> createState() => _SpringScreenState();
}

class _SpringScreenState extends State<SpringScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<ThemePicture> DUMMY_PICTURES = [
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/nature1.jpeg',
      highQualityUrl: './assets/images/nature1.jpeg',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/nature2.jpeg',
      highQualityUrl: './assets/images/nature2.jpeg',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/nature3.jpeg',
      highQualityUrl: './assets/images/nature3.jpeg',
      isPaid: false,
    ),
  ];
  List<ThemeVideo> DUMMY_VIDEOS = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
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
        appbarTitle: 'Spring',
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          topperTabar(_tabController),
          tapbarView(_tabController, gridPictures(DUMMY_PICTURES),
              gridVideos(DUMMY_VIDEOS))
        ],
      ),
    );
  }
}

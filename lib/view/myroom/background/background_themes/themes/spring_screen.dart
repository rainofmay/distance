import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/background_model.dart';

import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/tab_bar_view.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/topper_tab_bar.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';


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
      isPaid: true,
    ),
  ];
  List<ThemeVideo> DUMMY_VIDEOS = [
    ThemeVideo(
        id: 1,
        thumbnailUrl: './assets/videos/sea/sea1.png',
        highQualityUrl:
            "https://24cledbucket.s3.ap-northeast-2.amazonaws.com/sea/sea1.mp4",
        isPaid: false),
    ThemeVideo(
        id: 2,
        thumbnailUrl: './assets/videos/sea/sea2.png',
        highQualityUrl:
            "https://24cledbucket.s3.ap-northeast-2.amazonaws.com/sea/sea2.mp4",
        isPaid: false),
    ThemeVideo(
        id: 3,
        thumbnailUrl: './assets/videos/sea/sea3.png',
        highQualityUrl:
            "https://24cledbucket.s3.ap-northeast-2.amazonaws.com/sea/sea3.mp4",
        isPaid: true)
  ];

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
          topperTabBar(_tabController),
          tabBarView(_tabController, gridPictures(DUMMY_PICTURES),
              gridVideos(DUMMY_VIDEOS))
        ],
      ),
    );
  }
}

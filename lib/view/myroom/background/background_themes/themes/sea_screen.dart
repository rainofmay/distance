import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/background_model.dart';

import 'package:mobile/view/myroom/background/background_themes/themes/widget/gridItems.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/tab_bar_view.dart';
import 'package:mobile/view/myroom/background/background_themes/themes/widget/topper_tab_bar.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

class SeaScreen extends StatefulWidget {
  const SeaScreen({super.key});

  @override
  State<SeaScreen> createState() => _SeaScreenState();
}

class _SeaScreenState extends State<SeaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<ThemePicture> DUMMY_PICTURES = [
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_1.JPG',
      highQualityUrl: './assets/images/seas/sea_1.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_2.JPG',
      highQualityUrl: './assets/images/seas/sea_2.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_3.JPG',
      highQualityUrl: './assets/images/seas/sea_3.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_4.JPG',
      highQualityUrl: './assets/images/seas/sea_4.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_5.JPG',
      highQualityUrl: './assets/images/seas/sea_5.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_6.JPG',
      highQualityUrl: './assets/images/seas/sea_6.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_7.JPG',
      highQualityUrl: './assets/images/seas/sea_7.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_8.JPG',
      highQualityUrl: './assets/images/seas/sea_8.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_9.JPG',
      highQualityUrl: './assets/images/seas/sea_9.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_10.JPG',
      highQualityUrl: './assets/images/seas/sea_10.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_11.JPG',
      highQualityUrl: './assets/images/seas/sea_11.JPG',
      isPaid: false,
    ),
    ThemePicture(
      id: 1,
      thumbnailUrl: './assets/images/seas/sea_12.JPG',
      highQualityUrl: './assets/images/seas/sea_12.JPG',
      isPaid: false,
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
        isPaid: true),
    ThemeVideo(
        id: 3,
        thumbnailUrl: './assets/videos/sea/sea4.png',
        highQualityUrl:
        "https://24cledbucket.s3.ap-northeast-2.amazonaws.com/sea/sea4.mp4",
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
        appbarTitle: 'Sea',
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

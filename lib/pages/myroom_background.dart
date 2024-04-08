import 'package:flutter/material.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/myroom_background_setting.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});


  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}
//낮, 밤마다 시간마다 배경 설정 할 수 있게 하는 법 1. 사용자 설정, 2.
class _BackgroundSettingState extends State<BackgroundSetting> {
  int selectedImageCategoryIndex = 0; // 선택된 이미지 버튼의 ID
  int selectedImageIndex = 0;

  int selectedVideoCategoryIndex = 0; // 선택된 비디오 버튼의 ID
  int selectedVideoIndex = 0;

  bool isSettingOn = false;
  bool isImageSetting = true;
  List<String> imageCategories = ['Cafe', 'Jazz Bar', 'Nature'];// 카테고리 목록
  List<String> videoCategories = ['Sea', 'Stars' ,'river'];
  List<List<String>> images = [
    // 각 카테고리에 대한 이미지 목록
    [
      'assets/images/cafe1.jpeg',
      'assets/images/cafe2.jpeg',
      'assets/images/cafe3.jpeg',
    ],
    [
      'assets/images/jazz1.jpeg',
      'assets/images/jazz2.jpeg',
      'assets/images/jazz3.jpeg',
    ],
    [
      'assets/images/nature1.jpeg',
      'assets/images/nature2.jpeg',
      'assets/images/nature3.jpeg',
    ],
  ];
  List<List<String>> videos = [
    // 각 카테고리에 대한 이미지 목록
    [
      'assets/videos/sea(1080p).jpeg',
      'assets/videos/sea2(1080p).jpeg',
      'assets/videos/sea3(1080p).jpeg'
    ],
    [
      'assets/videos/gom1.jpeg',
    ],
    [
      'assets/videos/sea(1080p).jpeg',
    ],
  ];

  void handleImageButtonPressed(int categoryindex, int index, bool isImage) {
    // 클릭된 버튼의 ID를 저장하고 다른 버튼들을 비활성화
    //교체 필요 => 영상인지 아닌지에 따라 버튼 누르는 게 달라져야함.
    setState(() {
      selectedImageCategoryIndex = categoryindex;
      selectedImageIndex = index;
    });
    print("handleImageButtonPressed: $categoryindex");
    print("handleImageButtonPressed: $index");
    print('isImage : $isImage');
  }

  void handleSettingButtonPressed() {
    setState(() {
      isSettingOn = !isSettingOn;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              '배경 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: handleSettingButtonPressed,
                  icon: isSettingOn == true ? Icon(Icons.settings,  color: Colors.blue) : Icon(Icons.settings,)
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSettingOn =false;
                      isImageSetting = true;
                    });
                  },
                  icon: Icon(Icons.photo),
                  color: isImageSetting ? Colors.blue : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSettingOn =false;
                      isImageSetting = false;
                    });
                  },
                  icon: Icon(Icons.videocam),
                  color: isImageSetting ? Colors.grey : Colors.blue,
                ),
              ],
            ),
            //교체 필요 => 영상, 배경을 구분해둬야 함.
            // 카테고리 선택 페이지
          Expanded(
            child: isSettingOn == false ? (isImageSetting ? ListView.builder(
              scrollDirection: Axis.vertical, // 세로 스크롤 설정
              itemCount: imageCategories.length,
              itemBuilder: (context, index) {
                return buildImagePage(index);
              },
            ) : ListView.builder(
              scrollDirection: Axis.vertical, // 세로 스크롤 설정
              itemCount: videoCategories.length,
              itemBuilder: (context, index) {
                return buildVideoPage(index);
              },
            )) : BackgroundSettingSecond(),
          ),
            OkCancelButtons(
              onPressed: () {
                // 현재 화면을 pop하여 이전 화면으로 이동
                Navigator.pop(context);
              },
              okText: '확인', cancelText: '',
            ),
          ],
        ),
      ),
    );
  }

  // 카테고리당 이미지 선택 페이지 구성
  Widget buildImagePage(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${imageCategories[index]}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              images[index].length,
                  (imageIndex) {
                return CustomIconButton(
                  //교체 필요 => 불러오는 방식 + 캐싱 기능 탑재
                  imageUrl: images[index][imageIndex],
                  id: index * 100 + imageIndex,
                  onButtonPressed: () {handleImageButtonPressed(index, imageIndex, false);},
                  selectedCategoryIndex: index,
                  selectedIndex: imageIndex, // 값 전달
                  isImage: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
  Widget buildVideoPage(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${videoCategories[index]}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              videos[index].length,
                  (videoIndex) {
                return CustomIconButton(
                  //교체 필요 => 불러오는 방식 + 캐싱 기능 탑재
                  imageUrl: videos[index][videoIndex],
                  id: index * 100 + videoIndex,
                  onButtonPressed: () {handleImageButtonPressed(index, videoIndex, true);},
                  selectedCategoryIndex: index,
                  selectedIndex: videoIndex, // 값 전달
                  isImage: false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

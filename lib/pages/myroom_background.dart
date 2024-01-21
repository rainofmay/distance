import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/backgroundProvider.dart';
import '../widgets/icon_button.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});


  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}

class _BackgroundSettingState extends State<BackgroundSetting> {
  int selectedCategoryIndex = -1; // 선택된 버튼의 ID
  int selectedIndex = -1;
  List<String> categories = ['Cafe', 'Jazz Bar', 'Nature']; // 카테고리 목록
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

  void handleButtonPressed(int categoryindex, int index) {
    // 클릭된 버튼의 ID를 저장하고 다른 버튼들을 비활성화
    setState(() {
      selectedCategoryIndex = categoryindex;
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.read<BackgroundProvider>();


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
            // 카테고리 선택 페이지
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical, // 세로 스크롤 설정
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return buildCategoryPage(index);
                },
              ),
            ),
            // 확인 및 취소 버튼
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop(); // 닫히는 버튼
                    },
                  ),
                  TextButton(
                    child:
                        Text('Ok', style: TextStyle(color: Color(0xff0029F5))),
                    onPressed: () {
                      Navigator.of(context).pop(); // 닫히는 버튼
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 카테고리 선택 페이지 구성
  Widget buildCategoryPage(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${categories[index]}',
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
                  imageUrl: images[index][imageIndex],
                  id: index * 100 + imageIndex, // 고유한 ID 생성
                  onButtonPressed: ()=> handleButtonPressed(index, imageIndex),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

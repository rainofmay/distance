import 'package:flutter/material.dart';

import '../widgets/icon_button.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});

  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}

class _BackgroundSettingState extends State<BackgroundSetting> {
  int selectedButtonId = -1; // 선택된 버튼의 ID

  void handleButtonPressed(int id) {
    // 클릭된 버튼의 ID를 저장하고 다른 버튼들을 비활성화
    setState(() {
      selectedButtonId = id;
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
            // 세부 설정
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // 양 끝에 배치
                    children: [
                      Text(
                        '#테마 설정',
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
                    children: [
                      CustomIconButton(
                        imageUrl: 'assets/images/musictest.png',
                        id: 1,
                        onButtonPressed: handleButtonPressed,
                      ),
                      CustomIconButton(
                        imageUrl: 'assets/images/musictest.png',
                        id: 2,
                        onButtonPressed: handleButtonPressed,
                      ),
                      CustomIconButton(
                        imageUrl: 'assets/images/musictest.png',
                        id: 3,
                        onButtonPressed: handleButtonPressed,
                      ),
                      CustomIconButton(
                        imageUrl: 'assets/images/musictest.png',
                        id: 4,
                        onButtonPressed: handleButtonPressed,
                      ),
                      CustomIconButton(
                        imageUrl: 'assets/images/musictest.png',
                        id: 5,
                        onButtonPressed: handleButtonPressed,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // height: 30,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(); // 닫히는 버튼
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Color(0xff0029F5)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // 닫히는 버튼
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/widgets/music_volume.dart';

class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({super.key});

  @override
  State<BackgroundSetting> createState() => _BackgroundSettingState();
}

class _BackgroundSettingState extends State<BackgroundSetting> {
  bool isMusicOn = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 배치
                    children: [
                      Text(
                        '#테마 설정',
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal,),
                      ),
                      Switch(value: isMusicOn, onChanged: (value) {
                        setState(() {
                          isMusicOn = !isMusicOn;
                        });
                      })
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image(
                            image: AssetImage('assets/images/musictest.png'),
                            width: 70,
                            height: 80,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Image(
                            image: AssetImage('assets/images/musictest.png'),
                            width: 50,
                            height: 50,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Image(
                            image: AssetImage('assets/images/musictest.png'),
                            width: 50,
                            height: 50,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Image(
                            image: AssetImage('assets/images/musictest.png'),
                            width: 50,
                            height: 50,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Image(
                            image: AssetImage('assets/images/musictest.png'),
                            width: 50,
                            height: 50,
                          )),

                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // height: 30,
                  margin: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Cancel', style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(); // 닫히는 버튼
                        },
                      ),
                      TextButton(
                        child: Text('Ok', style: TextStyle(color: Color(0xff0029F5)),),
                        onPressed: () {
                          Navigator.of(context).pop(); // 닫히는 버튼
                        },
                      ),
                    ],
                  ),
                )],
            ),
          ],
        ),
      ),
    );
  }
}
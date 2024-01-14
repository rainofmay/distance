import 'package:flutter/material.dart';
import 'package:mobile/widgets/music_volume.dart';

class MusicSetting extends StatefulWidget {
  const MusicSetting({super.key});

  @override
  State<MusicSetting> createState() => _MusicSettingState();
}

class _MusicSettingState extends State<MusicSetting> {
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),),
      child: Container(
          width: 450,
          height: 800,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                '음악 설정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // 세부 설정
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      '#메인 뮤직',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal,),
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
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top:30),
                        child: Text(
                          '#음량 설정',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 260,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              MusicVolume(kindOfMusic: '메인 음악'),
                              MusicVolume(kindOfMusic: '여우비'),
                              MusicVolume(kindOfMusic: '소나기'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: screenSize.height*0.1),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // 닫히는 버튼
                          },
                        ),
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {},
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

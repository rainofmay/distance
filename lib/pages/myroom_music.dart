import 'package:flutter/material.dart';
import 'package:mobile/widgets/music_volume.dart';



class MusicSetting extends StatelessWidget {
  const MusicSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 450,
          height: 1000,
          padding: EdgeInsets.all(30),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top:30),
                        child: Text(
                          '#볼륨 설정',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                      MusicVolume(kindOfMusic: '메인 음악'),
                      MusicVolume(kindOfMusic: '여우비'),
                      MusicVolume(kindOfMusic: '소나기'),
                      MusicVolume(kindOfMusic: '우레'),
                      MusicVolume(kindOfMusic: '모닥불'),
                      MusicVolume(kindOfMusic: 'Cafe'),
                    ],
                  ),
                ],

              ),
              Container(
                margin: EdgeInsets.only(top: 60,),
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ),
    );
  }
}

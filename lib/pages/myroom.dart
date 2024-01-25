import 'package:flutter/material.dart'; // flutter 패키지 가져오는 코드
import 'package:mobile/widgets/action_buttons.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'package:mobile/pages/myroom_music.dart';
import 'package:mobile/pages/myroom_schedule.dart';
import 'package:provider/provider.dart';
import 'package:mobile/widgets/floating_todo.dart';
import 'package:mobile/pages/myroom_background.dart';
import '../util/backgroundProvider.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  @override
  Widget build(BuildContext context) {
    final backgroundProvider = Provider.of<BackgroundProvider>(context);

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/test.png'),
        ),
      )),
      floatingActionButton: ExpandableFab(
        distance: 60,
        sub: [
          ActionButton(
            // ActionBUtton : 커스터마이징된 버튼
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Schedule(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: Offset.zero)
                              .animate(animation),
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 140),
                      reverseTransitionDuration: Duration(milliseconds: 140),
                    ));
              },
              icon: Icon(Icons.edit_calendar_sharp,
                  size: 20, color: Colors.white70)),
          ActionButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false, // 바깥 터치해도 닫히는지
                  context: context,
                  builder: (context) {
                    return MusicSetting(); // MusicSetting 클래스의 인스턴스를 반환
                  });
            },
            icon: Icon(
              Icons.music_note_outlined,
              size: 20,
              color: Colors.white70,
            ),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false, // 바깥 터치해도 닫히는지
                  context: context,
                  builder: (context) {
                    return BackgroundSetting(); // MusicSetting 클래스의 인스턴스를 반환
                  });
            },
            icon: Icon(
              Icons.photo_camera_back,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}





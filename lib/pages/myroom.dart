import 'package:animations/animations.dart';
import 'package:flutter/material.dart'; // flutter 패키지 가져오는 코드
import 'package:mobile/widgets/action_buttons.dart';
import 'package:provider/provider.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'package:mobile/pages/myroom_background.dart';
import 'package:mobile/pages/myroom_memo.dart';
import 'package:mobile/pages/myroom_schedule.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  @override
  Widget build(BuildContext context) {
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
                    //다른 페이지로 이동할 때 원래 페이지의 배경이나 bottomNavigationBar를 유지하려면
                    //Navigator를 통해 페이지를 이동할 때 MaterialPageRoute가 아닌 PageRouteBuilder를 사용하여 직접 페이지를 만들고 설정

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
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Memo(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 140),
                    reverseTransitionDuration: Duration(milliseconds: 140),
                  ));
            },
            icon: Icon(Icons.post_add, size: 20, color: Colors.white70),
          ),
          ActionButton(
            onPressed: () {},
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

////상태 관리
// class Store1 extends ChangeNotifier {
//   bool isExpanded = false;
//   changeExpanded () {
//     isExpanded = !isExpanded;
//   }
// }



import 'package:flutter/material.dart'; // flutter 패키지 가져오는 코드
import 'package:mobile/widgets/optionicons.dart';
import 'package:provider/provider.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Store1(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/test.png'),
        )),
        child: Scaffold(
          floatingActionButton: SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                hoverColor: Colors.transparent,
                backgroundColor: Color(0xff333F50),
                onPressed: () {
                  context.read<Store1>().changeExpanded();
                },
              child: OptionIcons(),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

// https://velog.io/@foxy_dev/Compose-FloatingActionButton-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0


//상태 관리
class Store1 extends ChangeNotifier {
  bool isExpanded = false;
  changeExpanded () {
    isExpanded = !isExpanded;
  }
}


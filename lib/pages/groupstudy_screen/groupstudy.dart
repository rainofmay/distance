import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/pages/classroom_screen/classroom.dart';
import 'package:mobile/pages/groupstudy_screen/create_group_page.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/groupstudy/main/group_study_card.dart';


class GroupStudy extends StatefulWidget {
  GroupStudy({super.key});

  @override
  State<GroupStudy> createState() => _GroupStudyState();
}

class _GroupStudyState extends State<GroupStudy>
    with SingleTickerProviderStateMixin {

  final List<String> groupStudyNames = [
    '경찰대 준비생',
    '코딩 조별과제',
    // Add more group study names as needed
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BLACK,
        elevation: 10,
        title: Text('그룹스터디', style: TextStyle(color: WHITE, fontSize: 16),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CreateGroupPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 140),
                    reverseTransitionDuration: Duration(milliseconds: 140),
                  ));
            },
            icon: Icon(CupertinoIcons.add_circled_solid, color: WHITE, size: 18,),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search, color: WHITE, size: 18,),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              tabs: [
                Tab(
                  height: 40,
                  child: Text(
                    '전체',
                  ),
                ),
                Tab(
                  height: 40,
                  child: Text(
                    '참여 중',
                  ),
                ),
              ],
              splashBorderRadius: BorderRadius.circular(0),
              indicatorWeight: 1,
              controller: _tabController,
            ),
          ),
          BorderLine(lineHeight: 10, lineColor: Colors.transparent),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  // color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: groupStudyNames.length ,
                    // +1 for "그룹 생성하기" 버튼
                    itemBuilder: (BuildContext context, int index) {
                      return GroupStudyCard(
                          name: groupStudyNames[index],
                          onPressed: () {
                            // 실행될 함수 호출
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ClassRoom()));
                            print('Pressed ${groupStudyNames[index]}');
                          },
                          participantsNumber: 0,
                          availableNumber: 10,
                          imageAsset: 'assets/images/backgroundtest1.jpeg',
                        );
                      }
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Tab2 View',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



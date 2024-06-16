import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';

class SpringScreen extends StatefulWidget {
  const SpringScreen({super.key});

  @override
  State<SpringScreen> createState() => _SpringScreenState();
}

class _SpringScreenState extends State<SpringScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: 'Spring',
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
        actions: [
          IconButton(
            onPressed: () {}, // 배경 설정화면으로 라우팅하는 함수 필요
            icon: Icon(Icons.close_rounded),
          )
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 10),
        TabBar(
          tabs: [
            const Tab(height: 40, child: Text('사진/그림')),
            const Tab(height: 40, child: Text('영상')),
          ],
          splashBorderRadius: BorderRadius.circular(0),
          indicatorWeight: 1,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
        ),
        Expanded(child: TabBarView(
          controller: _tabController,
          children: [
            // 사진, 그림 Tab
            Container(
            ),

            // 영상 Tab
            Container(),
          ],
        ))
      ],),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common_function/custom_dialog.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/todo/new_todo.dart';
import 'package:mobile/widgets/todo/todo_list.dart';

class ScheduleTodo extends StatefulWidget {
  const ScheduleTodo({super.key});

  @override
  State<ScheduleTodo> createState() => _ScheduleTodoState();
}

class _ScheduleTodoState extends State<ScheduleTodo>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  final List<dynamic> _categories = [];

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                return null;
              },),
              SizedBox(
                height: 70,
                width: 70,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                    Icon(Icons.add_box_outlined, size: 35),
                      Text('목록')
                  ],),
                ),
              )
            ],
          ),
        ),
        BorderLine(lineHeight: 8, lineColor: Colors.grey.shade300),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              Expanded(
                child: TabBar(
                  tabs: [
                    Tab(
                      height: 40,
                      child: Text('진 행'),
                    ),
                    Tab(
                      height: 40,
                      child: Text('완 료'),
                    ),
                    Tab(
                      height: 40,
                      child: Text('중 요'),
                    )
                  ],
                  splashBorderRadius: BorderRadius.circular(0),
                  indicatorWeight: 1,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                ),
              ),
            ],
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
                child: Todo(),
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
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Tab3 View',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/myroom_calendar.dart';
import 'package:mobile/widgets/schedule/schedule_list.dart';
import 'package:mobile/util/calendar.dart';
import 'package:mobile/widgets/todo/todo_list.dart';
import 'package:provider/provider.dart';

class ScheduleTodo extends StatefulWidget {
  const ScheduleTodo({super.key});

  @override
  State<ScheduleTodo> createState() => _ScheduleTodoState();
}

class _ScheduleTodoState extends State<ScheduleTodo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     fit: BoxFit.cover,
      //     image: AssetImage('assets/images/test2.jpg'),
      //   ),
      // ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#카테고리'),
              SizedBox(height: 10,),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Text('${index}');
                    }),
              ),
              Container(
                height: 10,
                color: Colors.grey[200],
              ),
              TodoList(),
            ],
          ),
        ),
      ),
    );
  }
}

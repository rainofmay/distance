import 'package:flutter/material.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/todo/todo_list.dart';

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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#카테고리'),
            SizedBox(height: 10),
            SizedBox(
              height: 20,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Text('$index 번');
                  }),
            ),
           BorderLine(lineHeight: 8, backgroundColor: Colors.grey.shade200, lineColor: Colors.transparent),
            SizedBox(height: 10),
            Text('#과제 목록'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text('진행')),
                Text('|'),
                TextButton(onPressed: () {}, child: Text('완료')),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
                child: TodoList()),
          ],
        ),
      ),
    );
  }
}

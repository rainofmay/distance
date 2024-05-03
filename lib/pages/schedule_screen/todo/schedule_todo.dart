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
            Row(children: [
              TextButton(onPressed: (){}, child: Text('진행')),
              TextButton(onPressed: (){}, child: Text('완료')),
              TextButton(onPressed: (){}, child: Text('중요'))
            ]),
            const SizedBox(height: 10),
            BorderLine(lineHeight: 5, backgroundColor: Colors.grey.shade200, lineColor: Colors.transparent),
            const SizedBox(height: 10),
            const Text('#과제 목록'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text('진행')),
                Text('|'),
                TextButton(onPressed: () {}, child: Text('완료')),
              ],
            ),
            const SizedBox(height: 10),
            // SizedBox(
            //     child: TodoList()),
          ],
        ),
      ),
    );
  }
}

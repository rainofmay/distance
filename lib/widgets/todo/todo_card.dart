
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/schedule/schedule_bottom_sheet.dart';
import 'package:mobile/model/schedule_model.dart';

class TodoCard extends StatefulWidget {
  final String id;
  final String todoName;
  final DateTime selectedDate;
  final bool isDone;

  TodoCard({
    required this.id,
    required this.todoName,
    required this.selectedDate,
    required this.isDone,
    super.key,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late bool isDone ;

  @override
  void initState() {
    super.initState();
    isDone = widget.isDone;
  }

  updateToggle(newValue) async{
    print('updateToggle: ${newValue}');
    setState(() {
      isDone = newValue;
      print(widget.isDone);
    });
    await FirebaseFirestore.instance.collection('todo').doc(widget.id).update({'isDone': isDone});
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(value: isDone, onChanged: (value) => !isDone,),
              Text(widget.todoName, style: TextStyle(color: BLACK),),
            ],
          ),
        ),
      ),
    );
  }
}
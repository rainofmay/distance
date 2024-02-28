
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
  final List subTodoList;

  TodoCard({
    required this.id,
    required this.todoName,
    required this.selectedDate,
    required this.isDone,
    required this.subTodoList,
    super.key,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final List<Map<String, bool>> _subTodoList = [];
  late bool _isDone ;
  TextEditingController introduceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
  }

  updateToggle(newValue) async{
    print('updateToggle: ${newValue}');
    setState(() {
      _isDone = newValue;
    });
    await FirebaseFirestore.instance.collection('todo').doc(widget.id).update({'isDone': _isDone});
  }

  // 하위항목 to-do 추가
  addSubTodo(newValue) async {
    setState(() {
      _subTodoList.add({"title":newValue, "completed":false});
    });
    await FirebaseFirestore.instance.collection('todo').doc(widget.id).update({'subTodoList': _subTodoList});
  }
  
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(value: _isDone, onChanged: updateToggle,),
                      Text(widget.todoName, style: TextStyle(color: BLACK),),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border_rounded))
              ],
            ),
            // 하위항목 to-do
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:2, bottom: 2, left:20, right:10),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.add, color: Colors.grey, size: 14,)),
                    //Checkbox(value: isDone, onChanged: updateToggle,),
                    Container(
                      width: 250,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                        maxLength: 100,
                        controller: introduceController,
                        decoration: InputDecoration(
                          hintText: '하위항목 추가.',
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
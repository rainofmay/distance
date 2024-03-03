import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class TodoCard extends StatefulWidget {
  final String id;
  final String todoName;
  final DateTime selectedDate;
  final bool isDone;
  final List<dynamic> subTodoList;

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
  late List<dynamic> _subTodoList = [];
  late bool _isDone; //todo
  final bool _subIsDone = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
    _subTodoList = widget.subTodoList;
  }

  // void _onSavePressed() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //   }
  // }

  updateToggle(newValue) async {
    print('updateToggle: ${newValue}');
    setState(() {
      _isDone = newValue;
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'isDone': _isDone});
  }

  // 하위항목 to-do 추가
  addSubTodo(newValue, boolValue) async {
    setState(() {
      _subTodoList.add({"title": newValue, "completed": boolValue});
      print(_subTodoList);
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'subTodoList': _subTodoList});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
        height: 200,
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
                      Checkbox(
                        value: _isDone,
                        onChanged: updateToggle,
                      ),
                      Text(
                        widget.todoName,
                        style: TextStyle(color: BLACK),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.bookmark_border_rounded))
              ],
            ),
            // 하위항목 to-do
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 2, bottom: 2, left: 10, right: 10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _subTodoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          //edit to-dp
                        });
                      },
                      leading: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 14,
                          )),
                      //Checkbox(value: isDone, onChanged: updateToggle,),

                      title: Text(_subTodoList[index]["title"]),
                      trailing: IconButton(
                          onPressed: () {
                            addSubTodo(_controller.text, _subIsDone);
                          },
                          icon: Icon(
                            Icons.add_box_outlined,
                            color: Colors.grey,
                            size: 14,
                          )),
                    );
                  },
                ),
              ),
            ),
            TextField(
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  addSubTodo(value, _subIsDone);
                }
              },
              autofocus: true,
              textAlign: TextAlign.start,
              controller: _controller,
              // controller: _controller,
              // onTapOutside: (event) => {
              //     if (_controller.text.isNotEmpty) {
              //     addSubTodo(_controller.text, _subIsDone)},
              //   FocusManager.instance.primaryFocus?.unfocus(), // 바깥 터치했을 때 키보드 감추기
              // },
              style: TextStyle(color: Colors.black, fontSize: 11),
              maxLength: 20,

              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "한 글자 이상 입력하세요.";
              //   }
              //   return null;
              // },
              // onSaved: (val) {
              //   setState(() {
              //     print(val);
              //     addSubTodo(val as String, _subIsDone);
              //   });
              //   // FocusManager.instance.primaryFocus?.unfocus();
              // },
              decoration: InputDecoration(
                hintText: '하위항목 추가.',
                counterText: '',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

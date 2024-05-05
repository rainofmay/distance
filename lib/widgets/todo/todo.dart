import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/schedule_screen/todo/modify_todo.dart';
import 'dart:convert';
import 'package:mobile/util/calendar_provider.dart';
import 'package:provider/provider.dart';

import '../../const/colors.dart';

class Todo extends StatefulWidget {
  const Todo({
    super.key,
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController todoController = TextEditingController();
  List<Map<String, dynamic>> todoList = [];
  bool _isLoading = false;
  String? _error; //_error가 null일 수도 있지만, null이 아니라면, String이다.

  bool isBookMarked = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _setBookMark() {
    setState(() {
      isBookMarked = !isBookMarked;
    });
  }

  void _editTodo(int index) async {
    TextEditingController editController = TextEditingController();
    editController.text = todoList[index]['todo'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('할 일 수정'),
          content: TextField(
            controller: editController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              // 위젯은 MOUNTED라는 bool 값을 가지고 있으며, false인 경우엔 dispose된 것. mount 인 경우에만 setState를 호출해야 함.
              onPressed: () {
                if (mounted) {
                  setState(() {
                    todoList[index]['todo'] = editController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendTodo() async {
    if (_formKey.currentState!.validate()) {
      // 유효성 검사 통과한 경우에만 저장
      _formKey.currentState!.save();
    }
    String todo = todoController.text;
    setState(() {
      todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
    });
    todoController.text = '';
  }

  void _loadTodos() async {
    final uriTest = Uri.https(
        'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
        'kyujin-Todo.json');
    final response = await http.get(uriTest);
    Map<String, dynamic> loadedTodoList = json.decode(response.body);
    setState(() {
      for (final item in loadedTodoList.entries) {
        todoList.add({
          "id": item.key,
          "todo": item.value['todo'],
          "completed": item.value['completed']
        });
      }
      _isLoading = false;
    });
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _error = "오류가 생겼습니다. 잠시 후에 다시 시도해주세요!";
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index]['completed'] =
          !todoList[index]['completed']; // 체크박스 상태 변경
    });
  }

  void _deleteTodo(int index) {
    final uriTest = Uri.https(
        'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
        'kyujin-Todo/${todoList[index]['id']}.json');
    http.delete(uriTest);
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Checkbox(
                        splashRadius: 0,
                        activeColor: Colors.grey,
                        hoverColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: BLACK),
                        ),
                        value: todoList[index]['completed'],
                        onChanged: (bool? value) {
                          _toggleTodo(index);
                        },
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ModifyTodo()),
                          );
                          // _editTodo(index);
                        },
                        child: Text(todoList[index]['todo'],
                            style: todoList[index]['completed']
                                ? TextStyle(
                                    color: UNSELECTED,
                                    decoration: TextDecoration.lineThrough)
                                : TextStyle(
                                    color: BLACK,
                                    decoration: TextDecoration.none)),
                      ),
                      trailing: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        // 클릭할 때 효과
                        icon: Icon(
                          isBookMarked
                              ? Icons.bookmark
                              : Icons.bookmark_border_rounded,
                          color: Color(0xfff8ab1b),
                        ),
                        onPressed: () => _setBookMark(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

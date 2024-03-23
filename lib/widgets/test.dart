import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/widgets/bottomBar/main_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/util/calendar.dart';
import 'package:provider/provider.dart';

class Todo extends StatefulWidget {
  const Todo({super.key,});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TextEditingController introduceController = TextEditingController();
  List<Map<String, dynamic>> todoList = [];
  bool _isLoading = false;
  String? _error; //_error가 null일 수도 있지만, null이 아니라면, String이다.

  @override
  void initState() {
    super.initState();
    _loadTodos();
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
                if(mounted) {
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

  void sendTodo() {
    String todo = introduceController.text;
    final URI_TEST = Uri.https(
        'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
        'kyujin-Todo.json');
    http.post(URI_TEST, headers: {"Content-Type": "application/json"},
        body: json.encode({"todo": todo, "completed": false}));
    setState(() {
      todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
    });
    introduceController.text = '';
  }

  void _loadTodos() async {
    final URI_TEST = Uri.https(
        'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
        'kyujin-Todo.json');
    final response = await http.get(URI_TEST);
    Map<String, dynamic> loadedTodoList = json.decode(response.body);
    setState(() {
      for (final item in loadedTodoList.entries) {
        todoList.add(
            {
              "id": item.key,
              "todo": item.value['todo'],
              "completed": item.value['completed']
            });
      }
      _isLoading = false;
    });
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _error = "데이터 가져오기에 오류가 생겼습니다. 잠시 후에 다시 시도해주세요!";
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index]['completed'] =
      !todoList[index]['completed']; // 체크박스 상태 변경
    });
  }

  void _deleteTodo(int index) {
    final URI_TEST = Uri.https(
        'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
        'kyujin-Todo/${todoList[index]['id']}.json');
    http.delete(URI_TEST);
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator())
        : Column(
              children: [
        SizedBox(
          height: 200,
          // Column은 세로로 무한한 확장. ListView도 세로로 무한한 확장. => shrinkWrap은 필요한 공간만 차지하도록 설정
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: todoList[index]['completed'],
                  onChanged: (bool? value) {
                    _toggleTodo(index);
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    _editTodo(index);
                  },
                  child: Text(
                    todoList[index]['todo'
                    ],
                    style: TextStyle(
                      decoration: todoList[index]['completed'] ? TextDecoration
                          .lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[300],),
                  onPressed: () => _deleteTodo(index),
                ),
              );
            },
          ),
        ),
        SizedBox(
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: Colors.black, fontSize: 13),
            maxLength: 100,
            controller: introduceController,
            decoration: InputDecoration(
              prefixIcon: IconButton(onPressed: () {
                Provider.of<CalendarProvider>(context, listen: false).setCalendarVisible();
              }, icon: Icon(Icons.calendar_month_outlined, size: 18)),
              suffixIcon: IconButton(onPressed: sendTodo, icon: Icon(Icons.send, size: 18)),
              hintText: '일정을 입력해 주세요.',
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
              ],);
  }
}
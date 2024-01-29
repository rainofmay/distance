import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController introduceController = TextEditingController();
  List<Map<String, dynamic>> todoList = [];
  bool _isLoading = false;
  String? _error; //_err

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
                leading: ListView(
                  children: [Checkbox(
                    value: todoList[index]['completed'],
                    onChanged: (bool? value) {
                      _toggleTodo(index);
                    },
                    shape: CircleBorder(side: BorderSide(width: 3.0)), // 두께??
                  ), Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(width: 1, color: Colors.deepPurple)
                      )
                    ),
                  ),],
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
              );
            },
          ),
        ),
      ],);
  }
}
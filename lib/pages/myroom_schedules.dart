import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/widgets/main_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Schedule extends StatefulWidget {
  const Schedule({
    super.key,
  });

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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
              onPressed: () {
                setState(() {
                  todoList[index]['todo'] = editController.text;
                });
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
    final URI_TEST = Uri.https('study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app', 'kyujin-Todo.json');
    http.post(URI_TEST, headers: {"Content-Type" : "application/json"}, body: json.encode({"todo" : todo, "completed" : false}));
    setState(() {
      todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
    });
    introduceController.text = '';
  }

  void _loadTodos() async {
    final URI_TEST = Uri.https('study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app', 'kyujin-Todo.json');
    final response = await http.get(URI_TEST);
    Map<String, dynamic> loadedTodoList= json.decode(response.body);
    setState(() {
      for(final item in loadedTodoList.entries) {
        todoList.add(
            {"id": item.key, "todo": item.value['todo'], "completed": item.value['completed']});
      }
      _isLoading = false;
    });
    print(response.statusCode);
    if(response.statusCode >= 400) {
      _error = "데이터 가져오기에 오류가 생겼습니다. 잠시 후에 다시 시도해주세요!";
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index]['completed'] = !todoList[index]['completed']; // 체크박스 상태 변경
    });
  }

  void _deleteTodo(int index) {
    final URI_TEST = Uri.https('study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app', 'kyujin-Todo/${todoList[index]['id']}.json');
    http.delete(URI_TEST);
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                title: Text('To-do', style: TextStyle(fontSize: 16)),
                backgroundColor: Colors.white,
                centerTitle: true,
                shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.search, color: Colors.grey, size: 20),
                  )
                ],
              ),
            ],
          ),
        ),
      body: _isLoading ?  Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                        decoration: todoList[index]['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Colors.black, fontSize: 13),
              maxLength: 100,
              controller: introduceController,
              decoration: InputDecoration(
                prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, size: 18)),
                suffixIcon: IconButton(onPressed: sendTodo, icon: Icon(Icons.send, size: 18)),
                hintText: '메모를 입력하세요.',
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
      // bottomNavigationBar: CustomBottomNavagationBar(),
    );
  }
}

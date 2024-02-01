import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todos extends StatefulWidget {
  final selectedDate;
  const Todos({super.key, required this.selectedDate});

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
    getTodo();
  }

  getTodo() {
    var todos = FirebaseFirestore.instance.collection('todo').snapshots();
    print(todos);
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

  void _editTodo(int index) async {
    TextEditingController editController = TextEditingController();
    editController.text = todoList[index]['todo'];
  }

  void _toggleTodo(int index) {
    setState(() {
      // todoList[index]['completed']
      // !todoList[index]['completed'];
      // 체크박스 상태 변경
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
        : Expanded(child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('todo').where('날짜', isEqualTo: widget.selectedDate,).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('데이터를 가져오지 못했습니다.'),
          );
        } return Text('작성 중');
      },
    ));
  }
}

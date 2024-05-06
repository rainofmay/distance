import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/schedule_screen/todo/modify_todo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../const/colors.dart';
import '../../model/todo_model.dart';

class Todo extends StatefulWidget {
  // final Stream<List<Map<String, dynamic>>> stream;
  const Todo({
    super.key,
    // required this.stream,
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final supabase = Supabase.instance.client;
  var stream = Supabase.instance.client.from('todo').stream(primaryKey: ['id']);

  final _formKey = GlobalKey<FormState>();
  TextEditingController todoController = TextEditingController();
  bool _isLoading = false;
  String? _error; //_error가 null일 수도 있지만, null이 아니라면, String이다.

  bool isBookMarked = false;

  @override
  void initState() {
    super.initState();
    // _loadTodos();
  }

  // void _editTodo(int index) async {
  //   TextEditingController editController = TextEditingController();
  //   editController.text = todoList[index]['todo'];
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('할 일 수정'),
  //         content: TextField(
  //           controller: editController,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('취소'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('저장'),
  //             // 위젯은 MOUNTED라는 bool 값을 가지고 있으며, false인 경우엔 dispose된 것. mount 인 경우에만 setState를 호출해야 함.
  //             onPressed: () {
  //               if (mounted) {
  //                 setState(() {
  //                   todoList[index]['todo'] = editController.text;
  //                 });
  //               }
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void sendTodo() async {
  //   if (_formKey.currentState!.validate()) {
  //     // 유효성 검사 통과한 경우에만 저장
  //     _formKey.currentState!.save();
  //   }
  //   String todo = todoController.text;
  //   setState(() {
  //     todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
  //   });
  //   todoController.text = '';
  // }
  //
  // void _loadTodos() async {
  //   final uriTest = Uri.https(
  //       'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
  //       'kyujin-Todo.json');
  //   final response = await http.get(uriTest);
  //   Map<String, dynamic> loadedTodoList = json.decode(response.body);
  //   setState(() {
  //     for (final item in loadedTodoList.entries) {
  //       todoList.add({
  //         "id": item.key,
  //         "todo": item.value['todo'],
  //         "completed": item.value['completed']
  //       });
  //     }
  //     _isLoading = false;
  //   });
  //   print(response.statusCode);
  //   if (response.statusCode >= 400) {
  //     _error = "오류가 생겼습니다. 잠시 후에 다시 시도해주세요!";
  //   }
  // }
  //

  //
  // void _deleteTodo(int index) {
  //   final uriTest = Uri.https(
  //       'study-mate-f07ad-default-rtdb.europe-west1.firebasedatabase.app',
  //       'kyujin-Todo/${todoList[index]['id']}.json');
  //   http.delete(uriTest);
  //   setState(() {
  //     todoList.removeAt(index);
  //   });
  // }
  void toggleTodo(bool value, String id) async {
    await Supabase.instance.client
        .from('todo')
        .update({'is_done': value}).eq('id', id);
  }

  void setBookMark(bool value, String id) async {
    await Supabase.instance.client
        .from('todo')
        .update({'is_book_marked': value}).eq('id', id);
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

                // streamBuilder로 데이터 불러올 때는. Model.fromJson 쓰지 않고, 서버에 저장된 테이블 column명을 써야 한다.
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('데이터가 없습니다'),
                      );
                    }
                    final todos = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return ListTile(
                          leading: Checkbox(
                            splashRadius: 0,
                            activeColor: DARK,
                            checkColor: PRIMARY_COLOR,
                            hoverColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: BLACK),
                            ),
                            value: todo['is_done'],
                            onChanged: (bool? newValue) {
                              // 성능을 위해 넣는게 맞는데.. 왜 되는지는 모르겠다.
                              setState(() {
                                todo['is_done'] = newValue!;
                              });
                              toggleTodo(newValue!, todo['id']);
                            },
                          ),
                          title: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: RouteSettings(arguments: {
                                      'todoName': todo['todo_name'],
                                      'id': todo['id'],
                                      'isDone' : todo['is_done'],
                                      'isBookMarked' : todo['is_book_marked']
                                    }),
                                    builder: (context) => ModifyTodo()),
                              );
                              // _editTodo(index);
                            },
                            child: Text(todo['todo_name'],
                                style: todo['is_done']
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
                              todo['is_book_marked'] == true
                                  ? Icons.bookmark
                                  : Icons.bookmark_border_rounded,
                              color: PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              final bool newValue = !todo['is_book_marked'];
                              setState(() {
                                todo['is_book_marked'] = newValue;
                              });
                              setBookMark(newValue, todo['id']);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}

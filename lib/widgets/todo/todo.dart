import 'package:flutter/material.dart';
import 'package:mobile/view/schedule/todo/modify_todo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/const/colors.dart';
import '../borderline.dart';
import '../custom_check_box.dart';

class Todo extends StatefulWidget {
  final String column;
  final dynamic columnValue;

  const Todo({
    super.key,
    required this.column,
    required this.columnValue,
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  var supabase = Supabase.instance.client;
  String? _error; //_error가 null일 수도 있지만, null이 아니라면, String이다.

  @override
  void initState() {
    super.initState();
    // _loadTodos();
  }

  toggleTodo(bool value, String id) async {
    await Supabase.instance.client
        .from('todo')
        .update({'is_done': value}).eq('id', id);
  }

  setBookMark(bool value, String id) async {
    await Supabase.instance.client
        .from('todo')
        .update({'is_book_marked': value}).eq('id', id);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // streamBuilder로 데이터 불러올 때는. Model.fromJson 쓰지 않고, 서버에 저장된 테이블 column명을 써야 한다.
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('todo')
                .stream(primaryKey: ['id'])
                .eq(widget.column, widget.columnValue)
                .order('created_at', ascending: false)
                .order('is_book_marked', ascending: false),
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

                  return Column(
                    children: [
                      ListTile(
                        leading: CustomCheckBox(
                          value: todo['is_done'],
                          onChanged: (bool? newValue) async {
                            await toggleTodo(
                                newValue!, todo['id']); // supabase 저장
                            // 성능을 위해 넣는게 맞는데.. 왜 되는지는 모르겠다.
                            setState(() {
                              todo['is_done'] = newValue;
                            });
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
                                    'isDone': todo['is_done'],
                                    'isBookMarked': todo['is_book_marked']
                                  }),
                                  builder: (context) => ModifyTodo()),
                            );
                            // _editTodo(index);
                          },
                          child: Text(todo['todo_name'],
                              style: todo['is_done']
                                  ? TextStyle(
                                      color: GREY,
                                      decoration: TextDecoration.lineThrough)
                                  : TextStyle(
                                      color: BLACK,
                                      decoration: TextDecoration.none)),
                        ),
                        trailing: IconButton(
                          splashColor: TRANSPARENT,
                          hoverColor: TRANSPARENT,
                          highlightColor: TRANSPARENT,
                          // 클릭할 때 효과
                          icon: Icon(
                            todo['is_book_marked'] == true
                                ? Icons.bookmark
                                : Icons.bookmark_border_rounded,
                            color: PRIMARY_COLOR,
                          ),
                          onPressed: () async {
                            bool newValue = !todo['is_book_marked'];
                            await setBookMark(newValue, todo['id']);
                            setState(() {
                              todo['is_book_marked'] = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 5),
                        child: BorderLine(
                            lineHeight: 1,
                            lineColor: Colors.grey.withOpacity(0.1)),
                      ),
                    ],
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

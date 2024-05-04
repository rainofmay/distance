import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/todo_model.dart';
import 'package:mobile/widgets/todo/todo_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key,});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  TextEditingController introduceController = TextEditingController();
  // List<Map<String, dynamic>> todoList = [];
  final stream = Supabase.instance.client
      .from('todo')
      .stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('리스트를 가져오지 못했습니다.', style: TextStyle(color: BLACK),),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final todos =snapshot.data!.map((e) => TodoModel.fromJson(json: e)).toList();

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Dismissible(
              key: ObjectKey(todo.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) async {
                await Supabase.instance.client.from('todo').delete().match({
                  'id': todo.id,
                });
              },
              child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: TodoCard(
                    id: todo.id,
                    todoName: todo.todoName,
                    isDone : todo.isDone,
                    subTodoList: todo.subTodoList,
                  )),
            );
          },
        );
      },
    );
  }
}

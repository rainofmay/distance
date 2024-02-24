import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/todo_model.dart';
import 'package:mobile/widgets/todo/todo_card.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key,});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  TextEditingController introduceController = TextEditingController();
  List<Map<String, dynamic>> todoList = [];

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todo')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('과제 리스트를 가져오지 못했습니다.', style: TextStyle(color: BLACK),),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final todos = snapshot.data!.docs
            .map(
              (QueryDocumentSnapshot e) => TodoModel.fromJson(
              json: (e.data() as Map<String, dynamic>)),
        )
            .toList();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Dismissible(
              key: ObjectKey(todo.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) {
                FirebaseFirestore.instance
                    .collection('todo')
                    .doc(todo.id)
                    .delete();
              },
              child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: TodoCard(
                    id: todo.id,
                    todoName: todo.todoName,
                    selectedDate: todo.selectedDate,
                    isDone : todo.isDone,
                  )),
            );
          },
        );
      },
    );
  }
}

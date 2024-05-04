class TodoModel {
  final String id;
  final String todoName;

  // final DateTime selectedDate;
  final bool isDone;
  final List<dynamic> subTodoList;

  TodoModel({
    required this.id,
    required this.todoName,
    // required this.selectedDate,
    required this.isDone,
    required this.subTodoList,
  });

//JSON으로부터 모델을 만들어내는 생성자
  TodoModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        todoName = json['todo_name'],
        isDone = json['is_done'],
        subTodoList = json['sub_todo_list'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo_name': todoName,
      'is_done': isDone,
      'sub_todo_list': subTodoList,
    };
  }
  TodoModel copyWith({
    String? id,
    String? todoName,
    bool? isDone,
    List<dynamic>? subTodoList,
  }) {
    return TodoModel(
      id: id ?? this.id,
      todoName: todoName ?? this.todoName,
      isDone: isDone ?? this.isDone,
      subTodoList: subTodoList ?? this.subTodoList,
    );
  }
}

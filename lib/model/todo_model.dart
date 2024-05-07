class TodoModel {
  final String id;
  final String todoName;
  final bool isDone;
  final bool isBookMarked;
  // final List<dynamic> subTodoList;

  TodoModel({
    required this.id,
    required this.todoName,
    required this.isDone,
    required this.isBookMarked,
    // required this.subTodoList,
  });

//JSON으로부터 모델을 만들어내는 생성자
  TodoModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        todoName = json['todo_name'],
        isDone = json['is_done'],
        isBookMarked = json['is_book_marked'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo_name': todoName,
      'is_done': isDone,
      'is_book_marked': isBookMarked,
    };
  }
  TodoModel copyWith({
    String? id,
    String? todoName,
    bool? isDone,
    bool? isBookMarked,
  }) {
    return TodoModel(
      id: id ?? this.id,
      todoName: todoName ?? this.todoName,
      isDone: isDone ?? this.isDone,
      isBookMarked: isBookMarked ?? this.isBookMarked,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String todoName;
  final DateTime selectedDate;
  final Timestamp timeStamp;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.todoName,
    required this.selectedDate,
    required this.timeStamp,
    required this.isDone
  });

//JSON으로부터 모델을 만들어내는 생성자
  TodoModel.fromJson ({
    required Map<String, dynamic> json,
  })
      : id = json['id'],
        todoName = json['이름'],
        selectedDate = DateTime.parse(json['날짜']),
        timeStamp = json['timeStamp'],
        isDone = json['완료'];

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      '이름' : todoName,
      '날짜' : '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
      'timeStamp' : timeStamp,
      '완료' : isDone,
    };
  }
}


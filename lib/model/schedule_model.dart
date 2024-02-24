import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final Timestamp timeStamp;
  final String scheduleName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  // final String selectedRepeat;
  final String memo;
  final int selectedColor;
  final bool isDone;

  ScheduleModel({
    required this.id,
    required this.timeStamp,
    required this.scheduleName,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    // required this.selectedRepeat,
    required this.memo,
    required this.selectedColor,
    required this.isDone
  });

//JSON으로부터 모델을 만들어내는 생성자
  ScheduleModel.fromJson ({
    required Map<String, dynamic> json,
  })
      : id = json['id'],
        scheduleName = json['이름'],
        selectedDate = DateTime.parse(json['selectedDate']),
        startTime = json['시작'],
        endTime = json['종료'],
        timeStamp = json['timeStamp'],
        // selectedRepeat = json['반복'],
        memo = json['메모'],
        selectedColor = json['색상'],
        isDone = json['완료'];


  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      '이름' : scheduleName,
      'timeStamp' : timeStamp,
      'selectedDate' : '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
      '시작' : startTime,
      '종료' : endTime,
      // '반복' : selectedRepeat,
      '메모' : memo,
      '색상' : selectedColor,
      '완료' : isDone,
    };
  }
}
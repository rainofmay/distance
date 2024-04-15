import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;

  // final Timestamp createdAt;
  final String scheduleName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;

  // final String selectedRepeat;
  final String memo;
  final int sectionColor;
  final int selectedColor;
  final bool isDone;

  ScheduleModel(
      {required this.id,
      // required this.createdAt,
      required this.scheduleName,
      required this.selectedDate,
      required this.startTime,
      required this.endTime,
      // required this.selectedRepeat,
      required this.memo,
      required this.sectionColor,
      required this.selectedColor,
      required this.isDone});

//JSON으로부터 모델을 만들어내는 생성자
  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        scheduleName = json['schedule_name'],
        selectedDate = DateTime.parse(json['selected_date']),
        startTime = json['start_time'],
        endTime = json['end_time'],
        // createdAt = json['created_at'],
        // selectedRepeat = json['반복'],
        memo = json['memo'],
        sectionColor = json['section_color'],
        selectedColor = json['selected_color'],
        isDone = json['is_done'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_name': scheduleName,
      'selected_date':
          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
      'start_time': startTime,
      'end_time': endTime,
      // '반복' : selectedRepeat,
      'memo': memo,
      'section_color': sectionColor,
      'selected_color': selectedColor,
      'is_done': isDone
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? scheduleName,
    DateTime? selectedDate,
    String? startTime,
    String? endTime,
    String? memo,
    int? sectionColor,
    int? selectedColor,
    bool? isDone,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      // createdAt: createdAt,
      scheduleName: scheduleName ?? this.scheduleName,
      selectedDate: selectedDate ?? this.selectedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      memo: memo ?? this.memo,
      sectionColor: this.sectionColor,
      selectedColor: selectedColor ?? this.selectedColor,
      isDone: isDone ?? this.isDone,
    );
  }
}

import 'package:intl/intl.dart';

class ScheduleModel {
  final String id;
  final String scheduleName;
  final DateTime startDate;
  final DateTime endDate;
  final String? startTime;
  final String? endTime;
  final DateTime originalStartTime;
  final DateTime originalEndTime;
  final bool isTimeSet;
  final String memo;
  final int sectionColor;
  final String repeatType;
  final List<bool> repeatDays;
  final int repeatWeeks;
  final DateTime? repeatEndDate;

  ScheduleModel({
    required this.id,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    this.startTime,
    this.endTime,
    required this.originalStartTime,
    required this.originalEndTime,
    required this.isTimeSet,
    // required this.selectedRepeat,
    required this.memo,
    required this.sectionColor,
    this.repeatType = '반복 없음',
    this.repeatDays = const [],
    this.repeatWeeks = 1,
    this.repeatEndDate,
  });

//JSON으로부터 모델을 만들어내는 생성자
  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        scheduleName = json['schedule_name'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.parse(json['end_date']),
        startTime = json['start_time'],
        endTime = json['end_time'],
        originalStartTime = DateTime.parse(json['original_start_time']),
        originalEndTime = DateTime.parse(json['original_end_time']),
        isTimeSet = json['is_time_set'],
        memo = json['memo'],
        sectionColor = json['section_color'],
        repeatType = json['repeat_type'] ?? '반복 없음',
        repeatDays = List<bool>.from(json['repeat_days'] ?? []),
        repeatWeeks = json['repeat_weeks'] ?? 1,
        repeatEndDate = json['repeat_end_date'] != null
            ? DateTime.parse(json['repeat_end_date'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_name': scheduleName,
      'start_date':
          '${startDate.year}${startDate.month.toString().padLeft(2, '0')}${startDate.day.toString().padLeft(2, '0')}',
      'end_date':
          '${endDate.year}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}',
      'start_time': startTime,
      'end_time': endTime,
      'original_start_time': originalStartTime.toString(),
      'original_end_time': originalEndTime.toString(),
      'is_time_set': isTimeSet,
      // '반복' : selectedRepeat,
      'memo': memo,
      'section_color': sectionColor,
      'repeat_type': repeatType,
      'repeat_days': repeatDays,
      'repeat_weeks': repeatWeeks,
      'repeat_end_date': repeatEndDate?.toIso8601String(),
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    DateTime? originalStartTime,
    DateTime? originalEndTime,
    bool? isTimeSet,
    String? memo,
    int? sectionColor,
    String? repeatType,
    List<bool>? repeatDays,
    int? repeatWeeks,
    DateTime? repeatEndDate,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      originalStartTime: originalStartTime ?? this.originalStartTime,
      originalEndTime: originalEndTime ?? this.originalEndTime,
      isTimeSet: isTimeSet ?? this.isTimeSet,
      memo: memo ?? this.memo,
      sectionColor: this.sectionColor,
      repeatType: repeatType ?? this.repeatType,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatWeeks: repeatWeeks ?? this.repeatWeeks,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
    );
  }
}

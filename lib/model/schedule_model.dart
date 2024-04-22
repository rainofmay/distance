class ScheduleModel {
  final String id;
  final String scheduleName;
  final DateTime startDate;
  final DateTime endDate;
  final String? startTime;
  final String? endTime;
  final bool isTimeSet;
  // final String selectedRepeat;
  final String memo;
  final int sectionColor;

  ScheduleModel({
    required this.id,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    this.startTime,
    this.endTime,
    required this.isTimeSet,
    // required this.selectedRepeat,
    required this.memo,
    required this.sectionColor,
  });

//JSON으로부터 모델을 만들어내는 생성자
  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        scheduleName = json['schedule_name'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.parse(json['end_date']),
        startTime = json['start_time'],
        endTime = json['end_time'],
        isTimeSet = json['is_time_set'],
        memo = json['memo'],
        sectionColor = json['section_color'];

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
      'is_time_set': isTimeSet,
      // '반복' : selectedRepeat,
      'memo': memo,
      'section_color': sectionColor,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    bool? isTimeSet,
    String? memo,
    int? sectionColor,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isTimeSet: isTimeSet ?? this.isTimeSet,
      memo: memo ?? this.memo,
      sectionColor: this.sectionColor,
    );
  }
}

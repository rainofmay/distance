
class ScheduleModel {
  final String id;
  final String uid; // 추가된 Supabase UID
  final String groupId;
  final String scheduleName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isTimeSet;
  final String memo;
  final int sectionColor;
  final String repeatType;
  final List<bool> repeatDays;
  final int repeatWeeks;
  final DateTime repeatEndDate;
  final bool isDone;

  ScheduleModel({
    required this.id,
    required this.uid, // 추가된 Supabase UID
    required this.groupId,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    required this.isTimeSet,
    required this.memo,
    required this.sectionColor,
    this.repeatType = '반복 없음',
    this.repeatDays = const [],
    this.repeatWeeks = 1,
    required this.repeatEndDate,
    required this.isDone
  });

  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        uid = json['uid'], // 추가된 Supabase UID
        groupId = json['group_id'],
        scheduleName = json['schedule_name'],
        startDate = parseDateTime(json['start_date']),
        endDate = parseDateTime(json['end_date']),
        isTimeSet = json['is_time_set'],
        memo = json['memo'],
        sectionColor = json['section_color'],
        repeatType = json['repeat_type'] ?? '반복 없음',
        repeatDays = List<bool>.from(json['repeat_days'] ?? []),
        repeatWeeks = json['repeat_weeks'] ?? 1,
        repeatEndDate = DateTime.parse(json['repeat_end_date']),
        isDone = json['is_done'];

  static DateTime parseDateTime(String dateTimeString) {
    if (dateTimeString.length == 12) {
      int year = int.parse(dateTimeString.substring(0, 4));
      int month = int.parse(dateTimeString.substring(4, 6));
      int day = int.parse(dateTimeString.substring(6, 8));
      int hour = int.parse(dateTimeString.substring(8, 10));
      int minute = int.parse(dateTimeString.substring(10, 12));
      return DateTime(year, month, day, hour, minute);
    } else {
      throw FormatException('Invalid date time format: $dateTimeString');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid, // 추가된 Supabase UID
      'group_id': groupId,
      'schedule_name': scheduleName,
      'start_date': '${startDate.year}${startDate.month.toString().padLeft(2, '0')}${startDate.day.toString().padLeft(2, '0')}${startDate.hour.toString().padLeft(2, '0')}${startDate.minute.toString().padLeft(2, '0')}',
      'end_date': '${endDate.year}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}${endDate.hour.toString().padLeft(2, '0')}${endDate.minute.toString().padLeft(2, '0')}',
      'is_time_set': isTimeSet,
      'memo': memo,
      'section_color': sectionColor,
      'repeat_type': repeatType,
      'repeat_days': repeatDays,
      'repeat_weeks': repeatWeeks,
      'repeat_end_date': '${repeatEndDate.year}${repeatEndDate.month.toString().padLeft(2, '0')}${repeatEndDate.day.toString().padLeft(2, '0')}',
      'is_done': isDone,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? uid, // 추가된 Supabase UID
    String? groupId,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    bool? isTimeSet,
    String? memo,
    int? sectionColor,
    String? repeatType,
    List<bool>? repeatDays,
    int? repeatWeeks,
    DateTime? repeatEndDate,
    bool? isDone,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      uid: uid ?? this.uid, // 추가된 Supabase UID
      groupId: groupId ?? this.groupId,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isTimeSet: isTimeSet ?? this.isTimeSet,
      memo: memo ?? this.memo,
      sectionColor: sectionColor ?? this.sectionColor,
      repeatType: repeatType ?? this.repeatType,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatWeeks: repeatWeeks ?? this.repeatWeeks,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
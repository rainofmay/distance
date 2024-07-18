import 'dart:ui';

import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/calendar_info_model.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/widget/schedule/event.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleViewModel extends GetxController {
  final ScheduleRepository _repository;

  /* constructor */
  ScheduleViewModel({required ScheduleRepository repository})
      : _repository = repository;

  /* Provider */
  final ScheduleProvider scheduleProvider = ScheduleProvider();

  /* Calendar */
  late final Rx<CalendarInfoModel> _calendarInfo;
  DateTime get selectedDate => _calendarInfo.value.selectedDate;
  DateTime get focusedDate => _calendarInfo.value.focusedDate;

  late final Rx<CalendarFormat> _calendarFormat;

  CalendarFormat get calendarFormat => _calendarFormat.value;

  /* Schedule */
  late RxList<ScheduleModel> _allSchedules = <ScheduleModel>[].obs;
  List<ScheduleModel> get allSchedules => _allSchedules;

  final RxList<ScheduleModel> _selectedDateSchedules = <ScheduleModel>[].obs;
  List get selectedDateSchedules => _selectedDateSchedules;

  late final RxBool _isScheduleListLoaded;
  bool get isScheduleListLoaded => _isScheduleListLoaded.value;

  late final RxInt _colorIndex;
  int get colorIndex => _colorIndex.value;
  late var _selectedSectionColor;
  Color get selectedSectionColor => _selectedSectionColor.value;

  /* Repeat date */
  final RxList<String> _repeatTypes = ['반복없음', '지정'].obs;
  List<String> get repeatTypes => _repeatTypes;
  late final RxString _selectedRepeatType;
  String get selectedRepeatType => _selectedRepeatType.value;
  late final RxList<bool> _repeatDays ;
  List<bool> get repeatDays => _repeatDays;
  late final RxInt _repeatWeeks;
  int get repeatWeeks => _repeatWeeks.value;
  late final Rx<DateTime> _repeatEndDate ;
  DateTime get repeatEndDate => _repeatEndDate.value;

  @override
  void onInit() {
    initCalendarInfo();
    initAllSchedules();
    updateSelectedDate(selectedDate);
    initColorSet();
    _isScheduleListLoaded = false.obs;
    initRepeatData();
    super.onInit();
  }

  /* Init */
  Future<void> initCalendarInfo() async {
    _calendarInfo = CalendarInfoModel.selectedDate(
        selectedDate: DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    )).obs;

    _calendarFormat = CalendarFormat.week.obs;
  }

  Future<void> initAllSchedules() async {
    await _repository
        .fetchAllScheduleData()
        .then((value) => _allSchedules = value.obs)
        .then((value) => _isScheduleListLoaded.value = true);
    // print('_allSchedules $_allSchedules');
  }

  void initColorSet() {
    _colorIndex = 0.obs;
    _selectedSectionColor = sectionColors[0].obs;
  }

  initRepeatData() {
    _selectedRepeatType = _repeatTypes[0].obs;
    _repeatDays =  List.filled(7, false).obs;
    _repeatWeeks = 1.obs;
    _repeatEndDate = DateTime.now().add(Duration(days: 365 * 3)).obs;
  }

/* Update */
  void updateFocusedDate(DateTime focusedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      focusedDate: focusedDate,
    );
  }

  void updateSelectedDate(DateTime selectedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      selectedDate: selectedDate,
    );
    updateSelectedDateSchedules();
  }

  void updateSelectedDateSchedules() {
    // 선택된 날짜에 해당하는 일정들을 필터링
    _selectedDateSchedules.value = allSchedules.where((schedule) =>
    (schedule.startDate.year <= selectedDate.year &&
        schedule.startDate.month <= selectedDate.month &&
        schedule.startDate.day <= selectedDate.day) && (schedule.endDate.year >= selectedDate.year &&
        schedule.endDate.month >= selectedDate.month &&
        schedule.endDate.day >= selectedDate.day)
    ).toList();
  }

  void updateCalendarFormatToWeek() {
    _calendarFormat.value = CalendarFormat.week;
  }

  void updateCalendarFormatToMonth() {
    _calendarFormat.value = CalendarFormat.month;
  }

  Future<void> updateAllSchedules() async{
    await _repository
        .fetchAllScheduleData()
        .then((value) => _allSchedules.value = value);
  }

  void updateSelectedRepeatType(String? newValue) {
    if (newValue != null && newValue != _selectedRepeatType.value) {
      _selectedRepeatType.value = newValue;
    }
  }

  void updateRepeatDay(int index, bool selected) {
    if (_repeatDays[index] != selected) {
      final newList = List<bool>.from(_repeatDays);
      newList[index] = selected;
      _repeatDays.value = newList;
    }
  }

  void updateRepeatWeek(int? newValue) {
    if (newValue != null && newValue != _repeatWeeks.value) {
      _repeatWeeks.value = newValue;
    }
  }

  void updateRepeatEndDate(DateTime? newValue) {
    if (newValue != null && newValue != _repeatEndDate.value) {
      _repeatEndDate.value = newValue;
    }
  }


  void updateColorIndex(int index) {
    _colorIndex.value = index;
    _selectedSectionColor.value = sectionColors[index];
  }

  List initEvents(DateTime day) {
    List<dynamic> newData = [];
    for (int i = 0; i < _allSchedules.length; i++) {
      newData.add([
        _allSchedules[i].startDate.toUtc().add(Duration(hours: 9)),
        _allSchedules[i].endDate.toUtc().add(Duration(hours: 9)),
        _allSchedules[i].id,
        _allSchedules[i].sectionColor,
      ]);
    }
    return newData;
  }

  List<Object?> getEvents(DateTime day) {
    List<dynamic> data = initEvents(day);

    Map<DateTime, List<Event>> events = {};
    for (int i = 0; i < data.length; i++) {
      DateTime startDate = data[i][0];
      DateTime endDate = data[i][1];
      String id = data[i][2];

      while (
      startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        events.containsKey(startDate)
            ? events[startDate]!.contains(Event(id))
            ? null
            : events[startDate]!.add(Event(id))
            : events.addAll({
          startDate: [Event(id)]
        });
        startDate = startDate.add(Duration(days: 1));
      }
    }

    return events[day] ?? [];
  }

  // Map<String, int>
  Map<String, int> getEventsColor(day) {
    Map<String, int> idColorData = {};
    List data = initEvents(day);

    for (int i = 0; i < data.length; i++) {
      idColorData.addAll({data[i][2] : data[i][3]});
    }

    return idColorData;
  }
}

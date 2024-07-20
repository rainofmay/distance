import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/calendar_info_model.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/widget/schedule/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class ScheduleViewModel extends GetxController {
  final ScheduleRepository _repository;

  /* constructor */
  ScheduleViewModel({required ScheduleRepository repository})
      : _repository = repository;

  /* Provider */
  final ScheduleProvider scheduleProvider = ScheduleProvider();

  /* Calendar */
  late final Rx<CalendarInfoModel> _calendarInfo;
  CalendarInfoModel get calendarInfo => _calendarInfo.value;

  late final Rx<CalendarFormat> _calendarFormat;
  CalendarFormat get calendarFormat => _calendarFormat.value;

  /* Schedule */
  late RxList<ScheduleModel> _allSchedules = <ScheduleModel>[].obs;
  List<ScheduleModel> get allSchedules => _allSchedules;

  final RxList<ScheduleModel> _selectedDateSchedules = <ScheduleModel>[].obs;
  List get selectedDateSchedules => _selectedDateSchedules;

  late final RxBool _isScheduleListLoaded;
  bool get isScheduleListLoaded => _isScheduleListLoaded.value;

  late Rx<Color> _selectedSectionColor;
  Color get selectedSectionColor => _selectedSectionColor.value;

  late final Rx<TextEditingController> _titleController;
  TextEditingController get titleController => _titleController.value;
  late final Rx<TextEditingController> _memoController;
  TextEditingController get memoController => _memoController.value;

  late final Rx<ScheduleModel> _nowHandlingScheduleModel;

  ScheduleModel get nowHandlingScheduleModel => _nowHandlingScheduleModel.value;

  /* Repeat date */
  final RxList<String> _repeatTypes = ['반복없음', '지정'].obs;

  List<String> get repeatTypes => _repeatTypes;
  late final RxString _selectedRepeatType;

  String get selectedRepeatType => _selectedRepeatType.value;
  late final RxList<bool> _repeatDays;

  List<bool> get repeatDays => _repeatDays;
  late final RxInt _repeatWeeks;

  int get repeatWeeks => _repeatWeeks.value;
  late final Rx<DateTime> _repeatEndDate;

  DateTime get repeatEndDate => _repeatEndDate.value;


  /* '저장&수정' 버튼 활성화를 위한 유효성 검사 */
  final RxBool _isFormValid = false.obs;
  bool get isFormValid => _isFormValid.value;
  void updateFormValidity() {
    bool isTitleValid = _titleController().text.isNotEmpty && _titleController().text.length <= 60;
    bool isMemoValid = _memoController().text.length <= 200;

    bool isDateValid;
    if (_nowHandlingScheduleModel.value.isTimeSet) {
      // 시간이 설정된 경우: 날짜와 시간 모두 비교
      isDateValid = _nowHandlingScheduleModel.value.startDate.isBefore(_nowHandlingScheduleModel.value.endDate);
    } else {
      // 시간이 설정되지 않은 경우: 날짜만 비교
      DateTime startDate = DateTime(_nowHandlingScheduleModel.value.startDate.year,
          _nowHandlingScheduleModel.value.startDate.month,
          _nowHandlingScheduleModel.value.startDate.day);
      DateTime endDate = DateTime(_nowHandlingScheduleModel.value.endDate.year,
          _nowHandlingScheduleModel.value.endDate.month,
          _nowHandlingScheduleModel.value.endDate.day);
      isDateValid = startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate);
    }


    _isFormValid.value = isTitleValid && isMemoValid && isDateValid;
  }

  @override
  onInit() {
    initCalendarInfo(); // 초기화 문제 생길 수도 있음.

    _nowHandlingScheduleModel = Rx<ScheduleModel>(createInitialScheduleModel());

    _titleController = TextEditingController().obs;
    _memoController = TextEditingController().obs;

    _titleController.value.addListener(() {
      setScheduleName(_titleController.value.text);
    });
    _memoController.value.addListener(() {
      setScheduleMemo(_memoController.value.text);
    });

    _isScheduleListLoaded = false.obs;

    initAllSchedules().then((_) {
      updateSelectedDate(_calendarInfo.value.selectedDate);
      // updateSelectedDateSchedules();
      // _isScheduleListLoaded.value = true;
    });
    initColorSet();
    initRepeatData();
    super.onInit();
  }

  @override
  void dispose() {
    _titleController.value.dispose();
    _memoController.value.dispose();
    super.dispose();
  }

  /* Init */
  ScheduleModel createInitialScheduleModel() {
    final now = DateTime.now();
    final initialDate = DateTime(now.year, now.month, now.day, 8, 0); // 8:00 AM
    return ScheduleModel(
      id: Uuid().v4(),
      groupId: Uuid().v4(),
      scheduleName: '',
      startDate: DateTime(_calendarInfo.value.selectedDate.year, _calendarInfo.value.selectedDate.month,
          _calendarInfo.value.selectedDate.day, DateTime.now().hour, 0),
      endDate: DateTime(_calendarInfo.value.selectedDate.year, _calendarInfo.value.selectedDate.month,
          _calendarInfo.value.selectedDate.day, DateTime.now().hour+2, 0),
      isTimeSet: false,
      memo: '',
      sectionColor: 0,
      repeatType: _repeatTypes[0],
      repeatDays: List.filled(7, false),
      repeatWeeks: 1,
      repeatEndDate: initialDate.add(Duration(days: 365)),
    );
  }

  void initializeForNewSchedule() {
    _nowHandlingScheduleModel.value = createInitialScheduleModel();
    _titleController.value.text = '';
    _memoController.value.text = '';
    _selectedSectionColor.value = sectionColors[0];
    _selectedRepeatType.value = _repeatTypes[0];
    _repeatDays.value = List.filled(7, false);
    _repeatWeeks.value = 1;
    _repeatEndDate.value = DateTime.now().add(Duration(days: 365));
    update();
  }

  void initializeForEditSchedule(ScheduleModel schedule) {
    _nowHandlingScheduleModel.value = schedule;
    _titleController.value.text = schedule.scheduleName;
    _memoController.value.text = schedule.memo;
    _selectedSectionColor.value = sectionColors[schedule.sectionColor];
    _selectedRepeatType.value = schedule.repeatType;
    _repeatDays.value = List.from(schedule.repeatDays);
    _repeatWeeks.value = schedule.repeatWeeks;
    _repeatEndDate.value = schedule.repeatEndDate;
    update();
  }

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
    _allSchedules.value = await _repository.fetchAllScheduleData();
    _isScheduleListLoaded.value = true;
    update();
  }

  void initColorSet() {
    _selectedSectionColor = sectionColors[0].obs;
  }

  initRepeatData() {
    _selectedRepeatType = _repeatTypes[0].obs;
    _repeatDays = List.filled(7, false).obs;
    _repeatWeeks = 1.obs;
    _repeatEndDate = DateTime.now().add(Duration(days: 365 * 3)).obs;
  }

/* Update */
  void updateSchedule(ScheduleModel Function(ScheduleModel) update) {
    final updatedModel = update(_nowHandlingScheduleModel.value);
    _nowHandlingScheduleModel.value = updatedModel;
  }

  void setId(String id) {
    updateSchedule((s) => s.copyWith(id: id));
  }
  void setGroupId(String groupId) {
    updateSchedule((s) => s.copyWith(groupId: groupId));
  }

  void setScheduleName(String name) {
    updateSchedule((s) => s.copyWith(scheduleName: name));
    print(_nowHandlingScheduleModel.value.scheduleName);
  }

  void setScheduleMemo(String memo) {
    updateSchedule((s) => s.copyWith(memo: memo));
  }

  void setStartDate(DateTime start) {
    updateSchedule((s) => s.copyWith(startDate: start));
  }

  void setEndDate(DateTime end) {
    updateSchedule((s) => s.copyWith(endDate: end));
  }

  void toggleTimeSet() {
    updateSchedule((s) => s.copyWith(isTimeSet: !s.isTimeSet));
    updateFormValidity();
  }

  void setRepeatType(String type) {
    updateSchedule((s) => s.copyWith(repeatType: type));
  }

  void toggleRepeatDay(int dayIndex) {
    updateSchedule((s) {
      final newRepeatDays = List<bool>.from(s.repeatDays);
      newRepeatDays[dayIndex] = !newRepeatDays[dayIndex];
      return s.copyWith(repeatDays: newRepeatDays);
    });
  }

  void setRepeatWeek(int? newValue) {
    if (newValue != null && newValue != _nowHandlingScheduleModel.value.repeatWeeks) {
      updateSchedule((s) => s.copyWith(repeatWeeks: newValue));
    }
  }

  void setRepeatEndDate(DateTime? newValue) {
    if (newValue != null && newValue != _nowHandlingScheduleModel.value.repeatEndDate) {
      updateSchedule((s) => s.copyWith(repeatEndDate: newValue));
    }
  }

  void setSectionColorIndex(int index) {
    _selectedSectionColor.value = sectionColors[index];
    updateSchedule((s) => s.copyWith(sectionColor: index));
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

  void updateFocusedDate(DateTime focusedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      focusedDate: focusedDate,
    );
  }

  void updateSelectedDate(DateTime selectedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      selectedDate: selectedDate,
    );
    if (_isScheduleListLoaded.value) {
      updateSelectedDateSchedules();
    }
  }

  void updateSelectedDateSchedules() {
    // 선택된 날짜에 해당하는 일정들을 필터링
    _selectedDateSchedules.value = allSchedules
        .where((schedule) =>
            (schedule.startDate.year <= _calendarInfo.value.selectedDate.year &&
                schedule.startDate.month <= _calendarInfo.value.selectedDate.month &&
                schedule.startDate.day <= _calendarInfo.value.selectedDate.day) &&
            (schedule.endDate.year >= _calendarInfo.value.selectedDate.year &&
                schedule.endDate.month >= _calendarInfo.value.selectedDate.month &&
                schedule.endDate.day >= _calendarInfo.value.selectedDate.day))
        .toList();
    update();
  }


  void updateCalendarFormatToWeek() {
    _calendarFormat.value = CalendarFormat.week;
  }

  void updateCalendarFormatToMonth() {
    _calendarFormat.value = CalendarFormat.month;
  }

  Future<void> updateAllSchedules() async {
    await _repository
        .fetchAllScheduleData()
        .then((value) => _allSchedules.value = value);
    update();
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
  Map<String, int> getEventsColor(day) {
    Map<String, int> idColorData = {};
    List data = initEvents(day);

    for (int i = 0; i < data.length; i++) {
      idColorData.addAll({data[i][2]: data[i][3]});
    }

    return idColorData;
  }

  /* Create */
  createSchedule() async {
    try {
      await createRepeatingSchedules(nowHandlingScheduleModel);
      await updateAllSchedules();

      // 일정 개수가 10000개 이상인 경우 가장 오래된 일정 삭제
      if (_allSchedules.length >= 10000) {
        ScheduleModel oldestSchedule = _allSchedules.reduce((a, b) =>
        a.startDate.isBefore(b.startDate) ? a : b);
        await scheduleProvider.deleteScheduleData(oldestSchedule.id);
        await updateAllSchedules();
      }
      // 관련 UI 업데이트
      updateSelectedDate(nowHandlingScheduleModel.startDate);

      update();
    } catch (e) {
      print('Error creating schedule: $e');
      // 에러 처리 로직 추가
    }
  }

  createRepeatingSchedules(ScheduleModel baseSchedule) async {
    await scheduleProvider.createScheduleData(baseSchedule);

    DateTime currentDate = baseSchedule.endDate.add(Duration(days: 1));
    List<int> selectedDays = [];
    for (int i = 0; i < 7; i++) {
      if (baseSchedule.repeatDays[i]) {
        selectedDays.add(i);
      }
    }

    while (currentDate.isBefore(baseSchedule.repeatEndDate)) {
      for (int dayOffset in selectedDays) {
        int targetWeekday = (dayOffset + 1) % 7;
        if (targetWeekday == 0) targetWeekday = 7;

        int daysUntilTarget = (targetWeekday - currentDate.weekday + 7) % 7;
        DateTime scheduleDate = currentDate.add(Duration(days: daysUntilTarget));

        if (scheduleDate.isAfter(baseSchedule.endDate) &&
            scheduleDate.isBefore(baseSchedule.repeatEndDate)) {
          // 2 & 3. 하루짜리 반복 일정 생성
          DateTime newDate = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            baseSchedule.startDate.hour,
            baseSchedule.startDate.minute,
          );

          ScheduleModel repeatedSchedule = baseSchedule.copyWith(
            id: Uuid().v4(),
            startDate: newDate,
            endDate: newDate,  // startDate와 endDate를 같게 설정
          );

          await scheduleProvider.createScheduleData(repeatedSchedule);
        }
      }

      currentDate = currentDate.add(Duration(days: 7 * baseSchedule.repeatWeeks));
    }
  }
}

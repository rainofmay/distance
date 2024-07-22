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

  final RxMap<DateTime, List<Event>> _events = <DateTime, List<Event>>{}.obs;
  Map<DateTime, List<Event>> get events => _events;

  /* Repeat date */
  final RxList<String> _repeatTypes = ['반복없음', '지정'].obs;
  List<String> get repeatTypes => _repeatTypes;


  /* '저장&수정' 버튼 활성화를 위한 유효성 검사 */
  final RxBool _isFormValid = false.obs;
  bool get isFormValid => _isFormValid.value;
  void updateFormValidity() {
    bool isTitleValid = _titleController().text.isNotEmpty && _titleController().text.length <= 60;
    bool isMemoValid = _memoController().text.length <= 200;
    bool isRepeatValid = true;
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

    // 반복 일정인 경우 추가 검증
    if (_nowHandlingScheduleModel.value.repeatType == '지정') {
      isRepeatValid = _nowHandlingScheduleModel.value.startDate.year == _nowHandlingScheduleModel.value.endDate.year &&
          _nowHandlingScheduleModel.value.startDate.month == _nowHandlingScheduleModel.value.endDate.month &&
          _nowHandlingScheduleModel.value.startDate.day == _nowHandlingScheduleModel.value.endDate.day &&
          _nowHandlingScheduleModel.value.repeatDays[_nowHandlingScheduleModel.value.startDate.weekday - 1];
    }

    _isFormValid.value = isTitleValid && isMemoValid && isDateValid && isRepeatValid;
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
      repeatEndDate: initialDate.add(Duration(days: 91)),
    );
  }

  void initializeForNewSchedule() {
    final initialModel = createInitialScheduleModel();
    _nowHandlingScheduleModel.value = initialModel;
    _titleController.value.text = '';
    _memoController.value.text = '';
    _selectedSectionColor.value = sectionColors[0];
    // _selectedRepeatType.value = _repeatTypes[0];
    // _repeatDays.value = List.filled(7, false);
    // _repeatWeeks.value = 1;
    // _repeatEndDate.value = DateTime.now().add(Duration(days: 365));
    update();
  }

  void initializeForEditSchedule(ScheduleModel schedule) {
    _nowHandlingScheduleModel.value = schedule;
    _titleController.value.text = schedule.scheduleName;
    _memoController.value.text = schedule.memo;
    _selectedSectionColor.value = sectionColors[schedule.sectionColor];
    // _selectedRepeatType.value = schedule.repeatType;
    // _repeatDays.value = List.from(schedule.repeatDays);
    // _repeatWeeks.value = schedule.repeatWeeks;
    // _repeatEndDate.value = schedule.repeatEndDate;
    updateFormValidity();
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

/* Update */
  void updateHandlingScheduleValue(ScheduleModel Function(ScheduleModel) update) {
    final updatedModel = update(_nowHandlingScheduleModel.value);
    _nowHandlingScheduleModel.value = updatedModel;
  }

  void setScheduleName(String name) {
    updateHandlingScheduleValue((s) => s.copyWith(scheduleName: name));
  }

  void setScheduleMemo(String memo) {
    updateHandlingScheduleValue((s) => s.copyWith(memo: memo));
  }

  void setStartDate(DateTime start) {
    updateHandlingScheduleValue((s) {
      if (s.repeatType == '지정') {
        // 반복 일정일 경우
        DateTime newEnd = DateTime(
            start.year,
            start.month,
            start.day,
            s.endDate.hour,
            s.endDate.minute
        );

        // endDate가 startDate보다 이전이면 2시간 후로 설정
        if (newEnd.isBefore(start)) {
          newEnd = start.add(Duration(hours: 2));
        }

        return s.copyWith(
          startDate: start,
          endDate: newEnd,
        );
      } else {
        // 반복 일정이 아닐 경우
        DateTime newEnd = s.endDate;

        // endDate가 새로운 startDate보다 이전이면 2시간 후로 설정
        if (newEnd.isBefore(start)) {
          newEnd = start.add(Duration(hours: 2));
        }

        return s.copyWith(startDate: start, endDate: newEnd);
      }
    });
    updateFormValidity();
  }

  void setEndDate(DateTime end) {
    updateHandlingScheduleValue((s) {
      if (s.repeatType == '지정') {
        // 반복 일정일 경우
        DateTime newStart = DateTime(
            end.year,
            end.month,
            end.day,
            s.startDate.hour,
            s.startDate.minute
        );

        // startDate가 endDate보다 이후이면 2시간 전으로 설정
        if (newStart.isAfter(end)) {
          newStart = end.subtract(Duration(hours: 2));
        }

        return s.copyWith(
          startDate: newStart,
          endDate: end,
        );
      } else {
        // 반복 일정이 아닐 경우
        DateTime newStart = s.startDate;

        // startDate가 새로운 endDate보다 이후이면 2시간 전으로 설정
        if (newStart.isAfter(end)) {
          newStart = end.subtract(Duration(hours: 2));
        }

        return s.copyWith(startDate: newStart, endDate: end);
      }
    });
    updateFormValidity();
  }

  void toggleTimeSet() {
    updateHandlingScheduleValue((s) => s.copyWith(isTimeSet: !s.isTimeSet));
    updateFormValidity();
  }

  void setRepeatType(String type) {
    updateHandlingScheduleValue((s) {
      if (type == '지정') {
        // 시작일과 종료일의 날짜만 같게 설정하고, 시간은 유지
        DateTime startDate = s.startDate;
        DateTime endDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          s.endDate.hour,
          s.endDate.minute,
        );

        // 현재 요일을 선택
        List<bool> newRepeatDays = List.filled(7, false);
        newRepeatDays[startDate.weekday - 1] = true;

        return s.copyWith(
          repeatType: type,
          endDate: endDate,
          repeatDays: newRepeatDays,
        );
      } else {
        return s.copyWith(repeatType: type);
      }
    });
    updateFormValidity();
  }

  void setRepeatDay(int dayIndex) {
    updateHandlingScheduleValue((s) {
      final newRepeatDays = List<bool>.from(s.repeatDays);
      newRepeatDays[dayIndex] = !newRepeatDays[dayIndex];
      return s.copyWith(repeatDays: newRepeatDays);
    });
    updateFormValidity();
  }

  void setRepeatWeek(int? newValue) {
    if (newValue != null && newValue != _nowHandlingScheduleModel.value.repeatWeeks) {
      updateHandlingScheduleValue((s) => s.copyWith(repeatWeeks: newValue));
    }
  }

  void setRepeatEndDate(DateTime? newValue) {
    if (newValue != null && newValue != _nowHandlingScheduleModel.value.repeatEndDate) {
      updateHandlingScheduleValue((s) => s.copyWith(repeatEndDate: newValue));
    }
  }

  void setSectionColorIndex(int index) {
    _selectedSectionColor.value = sectionColors[index];
    updateHandlingScheduleValue((s) => s.copyWith(sectionColor: index));
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
    return _allSchedules.where((schedule) =>
    schedule.startDate.isBefore(day.add(Duration(days: 1))) &&
        schedule.endDate.isAfter(day.subtract(Duration(days: 1)))
    ).map((schedule) => [
      schedule.startDate,
      schedule.endDate,
      schedule.id,
      schedule.sectionColor,
    ]).toList();
  }

  List<Object?> getEvents(DateTime day) {
    List<dynamic> data = initEvents(day);
    List<Event> events = [];

    for (var item in data) {
      DateTime startDate = item[0];
      DateTime endDate = item[1];
      String id = item[2];

      if (day.isAfter(startDate.subtract(Duration(days: 1))) &&
          day.isBefore(endDate)) {
        events.add(Event(id));
      }
    }

    return events;

  }
  Map<String, int> getEventsColor(day) {
    Map<String, int> idColorData = {};
    List data = initEvents(day);

    for (int i = 0; i < data.length; i++) {
      idColorData.addAll({data[i][2]: data[i][3]});
    }
    print('idColorData $idColorData');
    return idColorData;
  }

  /* Create */
  createSchedule() async {
    try {
      if (_nowHandlingScheduleModel.value.repeatType == '지정') {
        await createRepeatingSchedules(_nowHandlingScheduleModel.value);
        print("Creating Repeatingschedule: ${_nowHandlingScheduleModel.value.toJson()}");
      } else {
        await scheduleProvider.createScheduleData(_nowHandlingScheduleModel.value);
      }
      await updateAllSchedules();

      // 일정 개수가 10000개 이상인 경우 가장 오래된 일정 삭제
      if (_allSchedules.length >= 10000) {
        ScheduleModel oldestSchedule = _allSchedules.reduce((a, b) =>
        a.startDate.isBefore(b.startDate) ? a : b);
        await scheduleProvider.deleteScheduleData(oldestSchedule.id);
        await updateAllSchedules();
      }
      // 관련 UI 업데이트
      updateSelectedDate(_nowHandlingScheduleModel.value.startDate);

      update();
    } catch (e) {
      print('Error creating schedule: $e');
      // 에러 처리 로직 추가
    }
  }

  Future<void> createRepeatingSchedules(ScheduleModel baseSchedule) async {
    // 최초 일정 생성
    await scheduleProvider.createScheduleData(baseSchedule);

    // 반복 요일이 선택되지 않았다면 여기서 종료
    if (!baseSchedule.repeatDays.contains(true) || baseSchedule.repeatType != '지정') {
      return;
    }

    DateTime currentDate = baseSchedule.endDate.add(Duration(days: 1));
    List<int> selectedDays = [];
    for (int i = 0; i < 7; i++) {
      if (baseSchedule.repeatDays[i]) {
        selectedDays.add(i);
      }
    }

    Set<DateTime> scheduledDates = <DateTime>{for (var d = baseSchedule.startDate; d.isBefore(baseSchedule.endDate.add(Duration(days: 1))); d = d.add(Duration(days: 1))) d};
    DateTime endDate = baseSchedule.repeatEndDate.add(Duration(days: 1));

    while (currentDate.isBefore(endDate)) {
      for (int dayOffset in selectedDays) {
        int targetWeekday = (dayOffset + 1) % 7;
        if (targetWeekday == 0) targetWeekday = 7;

        int daysUntilTarget = (targetWeekday - currentDate.weekday + 7) % 7;
        DateTime scheduleDate = currentDate.add(Duration(days: daysUntilTarget));

        if (scheduleDate.isAfter(baseSchedule.endDate) &&
            scheduleDate.isBefore(endDate) &&
            !scheduledDates.contains(DateTime(scheduleDate.year, scheduleDate.month, scheduleDate.day))) {

          DateTime newStartDate = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            baseSchedule.startDate.hour,
            baseSchedule.startDate.minute,
          );

          DateTime newEndDate = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            baseSchedule.endDate.hour,
            baseSchedule.endDate.minute,
          );

          ScheduleModel repeatedSchedule = baseSchedule.copyWith(
            id: Uuid().v4(),
            startDate: newStartDate,
            endDate: newEndDate,
          );

          await scheduleProvider.createScheduleData(repeatedSchedule);
          scheduledDates.add(scheduleDate);
        }
      }

      currentDate = currentDate.add(Duration(days: 7 * baseSchedule.repeatWeeks));
    }
  }

  /* Edit */
  Future<void> editSchedule() async {
    try {
      await scheduleProvider.editScheduleData(_nowHandlingScheduleModel.value);
      await updateAllSchedules();
      updateSelectedDate(_nowHandlingScheduleModel.value.startDate);
      update();
    } catch (e) {
      print('Error edit schedule: $e');
      // 에러 처리 로직 추가
    }
  }

  /* Delete */
  Future<void> deleteSchedule(ScheduleModel schedule, bool deleteAll) async {
    try {
      if (deleteAll) {
        // 그룹 ID를 사용하여 모든 관련 일정 삭제
        await scheduleProvider.deleteScheduleGroup(schedule.groupId);
      } else {
        // 현재 일정만 삭제
        await scheduleProvider.deleteScheduleData(schedule.id);
      }
      await updateAllSchedules();
      updateSelectedDate(_calendarInfo.value.selectedDate);
      update();
    } catch (e) {
      print('Error deleting schedule: $e');
    }
  }
}

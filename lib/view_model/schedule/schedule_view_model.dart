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

  /* Calendar */
  late final Rx<CalendarInfoModel> _calendarInfo;
  DateTime get selectedDate => _calendarInfo.value.selectedDate;
  DateTime get focusedDate => _calendarInfo.value.focusedDate;

  late final RxBool _isCalendarVisible;
  bool get isCalendarVisible => _isCalendarVisible.value;
  late final Rx<CalendarFormat> _calendarFormat;

  CalendarFormat get calendarFormat => _calendarFormat.value;

  /* Schedule */
  late final RxList<ScheduleModel> _allSchedules;
  List<ScheduleModel> get allSchedules => _allSchedules;

  late final RxList<ScheduleModel> _scheduleModel;
  List<ScheduleModel> get scheduleModel => _scheduleModel;

  late final RxBool _isScheduleListLoaded;
  bool get isScheduleListLoaded => _isScheduleListLoaded.value;

  late final RxInt _colorIndex;
  int get colorIndex => _colorIndex.value;

  late var _selectedSectionColor;
  Color get selectedSectionColor => _selectedSectionColor.value;

  /* Provider */
  final ScheduleProvider scheduleProvider = ScheduleProvider();

  @override
  void onInit() {
    initCalendarInfo();
    initScheduleData(selectedDate);
    initColorSet();
    _isScheduleListLoaded = false.obs;
    initAllSchedules();
    super.onInit();
    /* Event */
  }

  /* Init */
  Future<void> initCalendarInfo() async {
    _calendarInfo = CalendarInfoModel.selectedDate(
        selectedDate: DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    )).obs;

    _isCalendarVisible = true.obs;
    _calendarFormat = CalendarFormat.week.obs;
  }

  Future<void> initAllSchedules() async {
    await _repository
        .fetchAllScheduleData()
        .then((value) => _allSchedules = value.obs);
    // print('_allSchedules $_allSchedules');
  }

  Future<void> initScheduleData(DateTime day) async {
    await _repository
        .fetchScehduleData(day)
        .then((value) => _scheduleModel = value.obs)
        .then((value) => _isScheduleListLoaded.value = true);
  }

  void initColorSet() {
    _colorIndex = 0.obs;
    _selectedSectionColor = sectionColors[0].obs;
  }


/* Update */
  void updateSelectedDate(DateTime selectedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      selectedDate: selectedDate,
    );
  }

  void updateFocusedDate(DateTime focusedDate) {
    _calendarInfo.value = _calendarInfo.value.copyWith(
      focusedDate: focusedDate,
    );
  }

  void updateCalendarVisible() {
    _isCalendarVisible.value = !_isCalendarVisible.value;
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

  Future<void> updateScheduleData(DateTime day) async{
    _isScheduleListLoaded.value = false;
    await _repository
        .fetchScehduleData(day)
        .then((value) => _scheduleModel.value = value)
        .then((value) => _isScheduleListLoaded.value = true);
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
    print(idColorData);
    return idColorData;
  }
}

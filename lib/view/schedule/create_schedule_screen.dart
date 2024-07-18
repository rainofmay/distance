import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/functions/time_comarison.dart';
import 'package:mobile/view/schedule/widget/schedule/repeat_schedule.dart';
import 'package:mobile/view/schedule/widget/schedule/color_selection.dart';
import 'package:mobile/view/schedule/widget/schedule/omni_date_time_picker_theme.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));

  final _formKey = GlobalKey<FormState>();
  late String _scheduleName;
  late DateTime _startDate;
  late DateTime _endDate;
  String _startTime = "06:00 AM";
  String _endTime = "08:00 AM";
  DateTime _originalStartTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 0);
  DateTime _originalEndTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);

  String _memo = '';

  late int _sectionColor;
  late TextEditingController _textController;
  bool _isTimeSet = false;

  @override
  void initState() {
    _endDate = viewModel.selectedDate;
    _startDate = viewModel.selectedDate;
    _sectionColor = viewModel.colorIndex;
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // 텍스트 에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    _textController.dispose();
    super.dispose();
  }

  _termsForSave() {
    if (timeComparison(_originalStartTime, _originalEndTime, _isTimeSet) ==
            false ||
        _endDate.day < _startDate.day ||
        _textController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _createRepeatingSchedules(ScheduleModel baseSchedule) async {
    DateTime currentDate = baseSchedule.startDate;
    List<int> selectedDays = List.generate(7, (i) => viewModel.repeatDays[i] ? i : -1)
        .where((day) => day != -1)
        .toList();

    while (currentDate.isBefore(viewModel.repeatEndDate)) {
      for (int dayOffset in selectedDays) {
        int targetWeekday = (dayOffset + 1) % 7 + 1;
        int daysUntilTarget = (targetWeekday - currentDate.weekday + 7) % 7;
        DateTime scheduleDate = currentDate.add(Duration(days: daysUntilTarget));

        // 월의 마지막 날 처리
        if (scheduleDate.day > DateTime(scheduleDate.year, scheduleDate.month + 1, 0).day) {
          scheduleDate = DateTime(scheduleDate.year, scheduleDate.month + 1, 0);
        }

        if (scheduleDate.isAfter(baseSchedule.startDate) &&
            !scheduleDate.isAfter(viewModel.repeatEndDate)) {
          ScheduleModel repeatedSchedule = baseSchedule.copyWith(
            id: Uuid().v4(),
            startDate: scheduleDate,
            endDate: scheduleDate.add(baseSchedule.endDate.difference(baseSchedule.startDate)),
          );
          await viewModel.scheduleProvider.createScheduleData(repeatedSchedule);
        }
      }
      currentDate = currentDate.add(Duration(days: 7 * viewModel.repeatWeeks));
    }
  }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      // bool값 리턴
      _formKey.currentState!.save();
    }

    //일정 추가
    final schedule = ScheduleModel(
      id: Uuid().v4(),
      scheduleName: _scheduleName,
      startDate: _startDate,
      endDate: _endDate,
      startTime: _isTimeSet ? _startTime : "",
      endTime: _isTimeSet ? _endTime : "",
      originalStartTime: _originalStartTime,
      originalEndTime: _originalEndTime,
      isTimeSet: _isTimeSet,
      memo: _memo,
      sectionColor: _sectionColor,
      repeatType: viewModel.selectedRepeatType,
      repeatDays: viewModel.repeatDays,
      repeatWeeks: viewModel.repeatWeeks,
      repeatEndDate: viewModel.repeatEndDate,
    );

    if (viewModel.selectedRepeatType != '반복없음') {
      if (_startDate.year != _endDate.year ||
          _startDate.month != _endDate.month ||
          _startDate.day != _endDate.day) {
        return customDialog(
          context,
          120,
          '알림',
          Text('반복 일정을 생성하려면 시작일과 종료일이 같아야 합니다.', style: TextStyle(color: Colors.white)),
          OkCancelButtons(okText: '확인', onPressed: Navigator.of(context).pop),
        );
      }
    }

    Get.back(); // 여기에 위치해야 중복 생성 방지됨

    // 일정 개수가 10000개 이상인지 확인
    if (viewModel.allSchedules.length >= 10000) {
      // 가장 오래된 일정 찾기 및 삭제
      ScheduleModel oldestSchedule = viewModel.allSchedules
          .reduce((a, b) => a.startDate.isBefore(b.startDate) ? a : b);
      await viewModel.scheduleProvider.deleteScheduleData(oldestSchedule.id);
    }

    // 일정 생성 및 업데이트
    await viewModel.scheduleProvider
        .createScheduleData(schedule)
        .then((value) => viewModel.updateAllSchedules());

    // 반복 일정 생성 (필요한 경우)
    if (viewModel.selectedRepeatType == '지정') {
      await _createRepeatingSchedules(schedule);
    }

    // 모든 일정 업데이트 및 UI 갱신
    await viewModel.updateAllSchedules();

    // 이벤트 재랜더링과 연관 있는 기능
    viewModel.updateSelectedDate(_startDate);
  }

  Future<void> _getDateFromUser(
      {required BuildContext context, required bool isStartTime}) async {
    DateTime? pickerDate = await showOmniDateTimePicker(
      context: context,
      theme: OmniDateTimePickerTheme.theme,
      initialDate: isStartTime ? _originalStartTime : _originalEndTime,
      type: _isTimeSet
          ? OmniDateTimePickerType.dateAndTime
          : OmniDateTimePickerType.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10 + 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10 + 5)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 5,
      // secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(1)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 700,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (isStartTime == true) {
      setState(() {
        _originalStartTime = pickerDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 6, 0); // 시작, 종료시각 비교를 위한 변수

        _startDate = pickerDate ?? DateTime.now();
        _startTime = DateFormat('hh:mm a').format(pickerDate!) ?? "06:00 AM";
      });
    } else if (isStartTime == false) {
      setState(() {
        _originalEndTime = pickerDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 8, 0);

        _endDate = pickerDate ?? DateTime.now();
        _endTime = DateFormat('hh:mm a').format(pickerDate!) ?? "08:00 AM";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '',
        isCenterTitle: true,
        backFunction: () => Get.back(),
        backgroundColor: BLACK,
        contentColor: WHITE,
        actions: [
          ValueListenableBuilder(
            valueListenable: _textController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return TextButton(
                onPressed: _termsForSave() ? () => _onSavePressed() : null,
                child: Text(
                  '저장',
                  style:
                      TextStyle(color: _termsForSave() ? PRIMARY_LIGHT : GREY),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                // appBar와 body 간의 간격
                EdgeInsets.only(
              left: 8.0,
              top: 16.0,
            ),
            child: Obx(() => Column(
                  children: [
                    CustomTextField(
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      controller: _textController,
                      titleIcon: IconButton(
                          icon: Icon(CupertinoIcons.circle_filled,
                              color: viewModel.selectedSectionColor),
                          onPressed: () => customDialog(
                                context,
                                240,
                                '구분 색상',
                                Column(children: [
                                  ColorSelection(scheduleViewModel: viewModel)
                                ]),
                                TextButton(
                                  child: Text('확인',
                                      style: TextStyle(color: WHITE)),
                                  onPressed: () {
                                    _sectionColor = viewModel.colorIndex;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )),
                      hint: '일정을 입력해 주세요.',
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      maxLines: 1,
                      maxLength: 13,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          _scheduleName = val as String;
                        });
                      },
                    ),
                    CustomTextField(
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      titleIcon: IconButton(
                          icon: Icon(
                            Icons.sticky_note_2_outlined,
                            color: BLACK,
                          ),
                          onPressed: null),
                      hint: '메모를 입력해 보세요.',
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      maxLines: 1,
                      maxLength: 60,
                      validator: (value) {
                        if (value.toString().length > 60) {
                          return "60자 이내로 입력하세요.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _memo = value as String;
                        });
                      },
                    ),

                    // 시작 일시
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            autofocus: false,
                            readOnly: true,
                            onTap: () {
                              _getDateFromUser(
                                  context: context, isStartTime: true);
                            },
                            titleIcon: IconButton(
                                icon: Icon(
                                  Icons.edit_calendar_outlined,
                                  color: BLACK,
                                ),
                                onPressed: null),
                            hint: DateFormat.yMd().format(_startDate),
                          ),
                        ),
                        _isTimeSet
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: CustomTextField(
                                  onTap: () {
                                    _getDateFromUser(
                                        context: context, isStartTime: true);
                                  },
                                  autofocus: false,
                                  textAlign: TextAlign.right,
                                  readOnly: true,
                                  hint: _startTime,
                                ),
                              ))
                            : const SizedBox(),
                      ],
                    ),

                    // 종료 일시
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            autofocus: false,
                            readOnly: true,
                            onTap: () {
                              _getDateFromUser(
                                  context: context, isStartTime: false);
                            },
                            titleIcon: IconButton(
                                icon: Icon(
                                  Icons.edit_calendar_outlined,
                                  color: TRANSPARENT,
                                ),
                                onPressed: null),
                            hint: DateFormat.yMd().format(_endDate),
                            hintStyle: _endDate.day < _startDate.day
                                ? TextStyle(color: RED)
                                : TextStyle(),
                          ),
                        ),
                        _isTimeSet
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: CustomTextField(
                                  onTap: () {
                                    _getDateFromUser(
                                        context: context, isStartTime: false);
                                  },
                                  autofocus: false,
                                  textAlign: TextAlign.right,
                                  readOnly: true,
                                  hint: _endTime,
                                  hintStyle: timeComparison(_originalStartTime,
                                              _originalEndTime, _isTimeSet) ==
                                          false
                                      ? TextStyle(color: RED)
                                      : TextStyle(),
                                ),
                              ))
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 13.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Time'),
                          const SizedBox(width: 3),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _isTimeSet,
                              activeColor: Color(0xff8FB8EE),
                              //Color(0xffC8D8FA)
                              onChanged: (bool? value) {
                                setState(() {
                                  _isTimeSet = value ?? false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    RepeatScheduleWidget(),
                  ],
                )),
          ),
        ),
      )),
    );
  }
}

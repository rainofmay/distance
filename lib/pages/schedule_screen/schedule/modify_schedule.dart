import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/util/modifying_schedule_provider.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_dialog.dart';
import 'package:mobile/widgets/schedule/color_selection.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../model/schedule_model.dart';
import '../../../util/calendar_provider.dart';
import '../../../util/schedule_color_provider.dart';
import '../../../widgets/custom_text_field.dart';

class ModifySchedule extends StatefulWidget {
  const ModifySchedule({super.key});

  @override
  State<ModifySchedule> createState() => _ModifyScheduleState();
}

class _ModifyScheduleState extends State<ModifySchedule> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  var _scheduleName;

  late DateTime _startDate =
      context.read<ModifyingScheduleProvider>().modifyingStartDate;
  late DateTime _endDate =
      context.read<ModifyingScheduleProvider>().modifyingEndDate;

  late String _startTime =
      context.read<ModifyingScheduleProvider>().modifyingStartTime;
  late String _endTime =
      context.read<ModifyingScheduleProvider>().modifyingEndTime;
  late TimeOfDay _originalStartTime = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _originalEndTime = TimeOfDay(hour: 8, minute: 0);

  String _selectedRepeat = "없음";
  late String _memo = context.read<ModifyingScheduleProvider>().modifyingMemo;
  List<String> repeatList = [
    "없음",
    "매일",
    "주",
    "월",
  ];

  late int _sectionColor =
      context.read<ModifyingScheduleProvider>().modifyingColor;
  late bool _isTimeSet =
      context.read<ModifyingScheduleProvider>().modifyingIsTimeSet;

  // 시작 시각과 종료 시각 비교 함수
  bool _timeComparison(TimeOfDay start, TimeOfDay end) {
    if (start.hour < end.hour) {
      return true;
    } else if (start.hour == end.hour) {
      if (start.minute < end.minute) {
        return true;
      } else if (start.minute == end.minute) {
        // AM과 PM을 비교
        if (start.period == DayPeriod.am && end.period == DayPeriod.pm) {
          return true;
        }
      }
    }
    return false;
  }

  late TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
        text: context.read<ModifyingScheduleProvider>().modifyingName);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      // bool값 리턴
      _formKey.currentState!.save();
      if (_endDate.isBefore(_startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('종료일은 시작일보다 앞설 수 없습니다.'),
              duration: Duration(seconds: 1),
              dismissDirection: DismissDirection.down),
        );
        return;
      } else if (_timeComparison(_originalStartTime, _originalEndTime) ==
          false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('시작 시각은 종료 시각보다 앞설 수 없습니다.'),
            duration: Duration(seconds: 1),
            dismissDirection: DismissDirection.down,
          ),
        );
        return;
      }
    }

    // 새로고침을 위함도 있음.
    context.read<CalendarProvider>().setSelectedDate(_startDate);
    Navigator.of(context).pop();

    //일정 추가
    final schedule = ScheduleModel(
      id: Uuid().v4(),
      scheduleName: _scheduleName,
      startDate: _startDate,
      endDate: _endDate,
      startTime: _isTimeSet ? _startTime : "",
      endTime: _isTimeSet ? _endTime : "",
      isTimeSet: _isTimeSet,
      memo: _memo,
      sectionColor: _sectionColor,
    );

    final supabase = Supabase.instance.client;

    try {
      await supabase.from('schedule').insert(schedule.toJson());
    } catch (error) {
      print('에러 $error');
    }
  }

  Future<void> _getDateFromUser({required bool isStartTime}) async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      confirmText: '확인',
      cancelText: '취소',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      // locale: const Locale('ko', 'KR'),
      initialDate: context.read<ModifyingScheduleProvider>().modifyingStartDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              iconButtonTheme: IconButtonThemeData(
                  style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              )),
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(
                    255, 195, 221, 243), // header background color
                onPrimary: CALENDAR_COLOR, // 선택된 날짜 색상
                onSurface: BLACK,
                onBackground: Colors.grey, // 위와 아래의 경계선 색상
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: BLACK,
                ),
              ),
            ),
            child: child!);
      },
    );
    if (isStartTime == true) {
      setState(() {
        _startDate = pickerDate ?? DateTime.now();
      });
    } else if (isStartTime == false) {
      setState(() {
        _endDate = pickerDate ?? DateTime.now();
      });
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (!context.mounted) return;
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _originalStartTime = pickedTime;
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _originalEndTime = pickedTime;
        _endTime = formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: 6,
          //hour: int.parse(startTime.split(":")[0]),
          minute: 0,
          //minute:int.parse(startTime.split(":")[1].split(" ")[0])
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> modifyElements = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '',
        backFunction: Navigator.of(context).pop,
        backgroundColor: BLACK,
        contentColor: WHITE,
        actions: [
          ValueListenableBuilder(
            valueListenable: _textController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return TextButton(
                onPressed: (value.text.isEmpty)
                    ? null
                    : () => {
                          _onSavePressed(),
                        },
                child: Text(
                  '수정',
                  style:
                      TextStyle(color: value.text.isEmpty ? UNSELECTED : WHITE),
                ),
              );
            },
          ),
          TextButton(
            onPressed: () async {
              await supabase.from('schedule').delete().match({
                'id': context
                    .read<ModifyingScheduleProvider>()
                    .modifyingScheduleId
              });
              if (!context.mounted) return;
              context.read<CalendarProvider>().setSelectedDate(
                  _startDate); // 재랜더링에 필요한 코드,* 일정 사라지는 애니메이션 검토
              Navigator.of(context).pop();
            },
            child: Text(
              '삭제',
              style: TextStyle(color: WHITE),
            ),
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
            child: Column(
              children: [
                CustomTextField(
                  textInputAction: TextInputAction.done,
                  readOnly: false,
                  controller: _textController,
                  titleIcon: IconButton(
                      icon: Icon(CupertinoIcons.circle_filled,
                          color: context
                              .watch<ScheduleColorProvider>()
                              .selectedSectionColor),
                      onPressed: () => customDialog(
                            context,
                            '구분 색상',
                            null,
                            ColorSelection(),
                            TextButton(
                              child:
                                  Text('확인', style: TextStyle(color: COLOR1)),
                              onPressed: () {
                                _sectionColor = context
                                    .read<ScheduleColorProvider>()
                                    .colorIndex;
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
                        readOnly: true,
                        onTap: () {
                          _getDateFromUser(isStartTime: true);
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
                              textAlign: TextAlign.right,
                              readOnly: true,
                              hint: _startTime,
                              onTap: () {
                                _getTimeFromUser(isStartTime: true);
                              },
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
                        readOnly: true,
                        onTap: () {
                          _getDateFromUser(isStartTime: false);
                        },
                        titleIcon: IconButton(
                            icon: Icon(
                              Icons.edit_calendar_outlined,
                              color: TRANSPARENT,
                            ),
                            onPressed: null),
                        hint: DateFormat.yMd().format(_endDate),
                      ),
                    ),
                    _isTimeSet
                        ? Expanded(
                            child: Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: CustomTextField(
                              textAlign: TextAlign.right,
                              readOnly: true,
                              hint: _endTime,
                              onTap: () {
                                _getTimeFromUser(isStartTime: false);
                              },
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
                          activeColor: Color(0xffC8D8FA),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        titleIcon: IconButton(
                          icon: Icon(
                            Icons.repeat,
                            color: BLACK,
                          ),
                          onPressed: null,
                        ),
                        readOnly: true,
                        hint: _selectedRepeat,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: DropdownButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                        iconSize: 24,
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRepeat = newValue!;
                          });
                        },
                        items: repeatList
                            .map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value!,
                                style: TextStyle(color: UNSELECTED),
                              ));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

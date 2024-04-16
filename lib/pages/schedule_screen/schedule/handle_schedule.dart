import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/colors.dart';
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
import '../../../widgets/ok_cancel._buttons.dart';

class HandleSchedule extends StatefulWidget {
  const HandleSchedule({super.key});

  @override
  State<HandleSchedule> createState() => _HandleScheduleState();
}

class _HandleScheduleState extends State<HandleSchedule> {
  // 위젯을 고유하게 식별하는 키
  final _formKey = GlobalKey<FormState>();
  late String _scheduleName;

  DateTime _selectedDate = DateTime.now();

  // final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());

  // String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _startTime = "06:00 AM";
  String _endTime = "09:00 PM";
  String _selectedRepeat = "없음";
  String _memo = '';
  List<String> repeatList = [
    "없음",
    "매일",
    "주",
    "월",
  ];

  int _selectedColor = 0;
  int _sectionColor = 0;
  final bool _isDone = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    _textController.dispose();
    super.dispose();
  }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      // bool값 리턴
      _formKey.currentState!.save();
    }
    Navigator.of(context).pop();
    //스케줆 모델 생성
    final schedule = ScheduleModel(
        id: Uuid().v4(),
        scheduleName: _scheduleName,
        selectedDate: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        memo: _memo,
        sectionColor: _sectionColor,
        selectedColor: _selectedColor,
        isDone: _isDone);

    final supabase = Supabase.instance.client;
    print(schedule.toJson());
    try {
      await supabase.from('schedule').insert(schedule.toJson());
    } catch (e) {
      print('에러 $e.toString()');
    }
  }

  Future<void> _getDateFromUser({required bool isStartTime}) async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      // locale: const Locale('ko', 'KR'),
      initialDate: context.read<CalendarProvider>().selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
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
                )
              ),
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
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print('Error');
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
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
    _sectionColor = context
        .read<ScheduleColorProvider>()
        .colorIndex; // index를 선택하지 않았을 떄 default가 0이 되는 걸 막기 위함.

    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '',
        backFunction: Navigator.of(context).pop,
        backgroundColor: BLACK,
        contentColor: WHITE,
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return TextButton(
                onPressed: (value.text.isEmpty) ? null : () => _onSavePressed(),
                child: Text(
                  '저장',
                  style:
                      TextStyle(color: value.text.isEmpty ? UNSELECTED : WHITE),
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
                              child: Text('확인',
                                  style: TextStyle(color: COLOR1)),
                              onPressed: () {
                                _sectionColor = context
                                    .read<ScheduleColorProvider>()
                                    .colorIndex; // DB 모델에 저장
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
                    if (value.toString().length > 50) {
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
                        hint: DateFormat.yMd().format(
                            context.read<CalendarProvider>().selectedDate),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: CustomTextField(
                        textAlign: TextAlign.right,
                        readOnly: true,
                        hint: _startTime,
                        onTap: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    )),
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
                        hint: DateFormat.yMd().format(
                            context.read<CalendarProvider>().selectedDate),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: CustomTextField(
                        textAlign: TextAlign.right,
                        readOnly: true,
                        hint: _endTime,
                        onTap: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    )),
                  ],
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
                        underline: Container(
                          height: 0,
                        ),
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

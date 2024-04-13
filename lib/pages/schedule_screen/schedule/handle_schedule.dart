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
import '../../../util/calendar.dart';
import '../../../widgets/custom_text_field.dart';

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
        initialDate: context.read<CalendarProvider>().selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2999));
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print('Error');
    }

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
        child: Container(
            color: WHITE,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 8.0, top: 16.0, bottom: bottomInset),
                child: Column(
                  children: [
                    CustomTextField(
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      controller: _textController,
                      titleIcon: IconButton(
                        icon: Icon(CupertinoIcons.cube_fill,
                            color: Color(0xff081049)),
                        onPressed: () => showDialog(context: context, builder: (context) => AlertDialog(
                          content: SizedBox(width: 400, child: ColorSelection()),
                        ))
                      ),
                      hint: '일정을 입력해 주세요.',
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
                      maxLines: 1,
                      maxLength: 50,
                      validator: (value) {
                        if (value.toString().length > 50) {
                          return "50자 이내로 입력하세요.";
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
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 28, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "색상 선택",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'GmarketSansTTFMedium',
                                    color: Colors.grey),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 18.0),
                              SizedBox(
                                width: 300,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: cardColor.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    //1 개의 행에 보여줄 item 개수
                                    childAspectRatio: 2,
                                    //item 의 가로 1, 세로 1 의 비율
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = index;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: _selectedColor == index
                                                      ? Colors.black
                                                      : Color.fromRGBO(
                                                          0, 0, 0, 0.3),
                                                  width: _selectedColor == index
                                                      ? 2
                                                      : 1)),
                                          child: CircleAvatar(
                                              radius: 18,
                                              backgroundColor: cardColor[index]
                                                  [0],
                                              child: Icon(
                                                Icons.bookmark_added_outlined,
                                                color: cardColor[index][1],
                                                size: 18,
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      )),
    );
  }
}

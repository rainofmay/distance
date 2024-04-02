import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:uuid/uuid.dart';

final firestore = FirebaseFirestore.instance;

class ScheduleBottomSheet extends StatefulWidget {
  // final DateTime selectedDate;
  // final int? scheduleId;
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  // 위젯을 고유하게 식별하는 키
  final _formKey = GlobalKey<FormState>();

  String _scheduleName = '';
  DateTime _selectedDate = DateTime.now();
  final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());

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

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    Navigator.of(context).pop();
    //스케줆 모델 생성
    final schedule = ScheduleModel(
        id: Uuid().v4(),
        scheduleName: _scheduleName,
        timeStamp: _timeStamp,
        selectedDate: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        memo: _memo,
        selectedColor: _selectedColor,
        isDone: _isDone);

    await firestore
        .collection('schedule')
        .doc(schedule.id)
        .set(schedule.toJson());
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2999));
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
        child: Form(
      key: _formKey,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.8 + bottomInset,
          color: WHITE,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: '일정 제목',
                      hint: '입력된 거 또는 빈 칸',
                      maxiLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "한 글자 이상 입력하세요.";
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
                      label: '메 모',
                      hint: '메모를 입력해 보세요.',
                      onSaved: (value) {
                        setState(() {
                          _memo = value as String;
                        });
                      },
                    ),
                    CustomTextField(
                      label: '날 짜',
                      hint: DateFormat.yMd().format(_selectedDate),
                      widget: IconButton(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: _getDateFromUser),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomTextField(
                          label: "시 작",
                          hint: _startTime,
                          widget: IconButton(
                              onPressed: () {
                                _getTimeFromUser(isStartTime: true);
                              },
                              icon: Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey,
                              )),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: CustomTextField(
                          label: "종 료",
                          hint: _endTime,
                          widget: IconButton(
                              onPressed: () {
                                _getTimeFromUser(isStartTime: false);
                              },
                              icon: Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey,
                              )),
                        )),
                      ],
                    ),
                    CustomTextField(
                      label: '반 복',
                      hint: _selectedRepeat,
                      widget: DropdownButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 20,
                        elevation: 4,
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
                                style: TextStyle(color: Colors.grey),
                              ));
                        }).toList(),
                      ),
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
                              SizedBox(height: 18.0),
                              SizedBox(
                                width: 400,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: cardColor.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
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
                                            const EdgeInsets.only(right: 8.0),
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
                                              child: index == 11
                                                  ? Text(
                                                      '반투명',
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.black),
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .bookmark_added_outlined,
                                                      color: cardColor[index]
                                                          [1],
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
                    OkCancelButtons(
                        okText: '저장',
                        cancelText: '취소',
                        onPressed: _onSavePressed),
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}

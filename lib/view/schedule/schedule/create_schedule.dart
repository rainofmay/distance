import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/widgets/schedule/color_selection.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../model/schedule_model.dart';
import '../../../util/calendar_provider.dart';
import '../../../util/schedule_color_provider.dart';
import '../../../widgets/custom_text_field.dart';
import 'functions/time_comarison.dart';


class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  final _formKey = GlobalKey<FormState>();
  late String _scheduleName;
  late DateTime _startDate = context.read<CalendarProvider>().selectedDate;
  late DateTime _endDate = context.read<CalendarProvider>().selectedDate;
  String _startTime = "06:00 AM";
  String _endTime = "08:00 AM";
  DateTime _originalStartTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 0);
  DateTime _originalEndTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);

  String _selectedRepeat = "없음";
  String _memo = '';
  List<String> repeatList = [
    "없음",
    "매일",
    "주",
    "월",
  ];

  int _sectionColor = 0;
  final TextEditingController _textController = TextEditingController();
  bool _isTimeSet = true;

  // GlobalKey<MyRoomState> myRoomKey = GlobalKey();

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
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
      isTimeSet: _isTimeSet,
      memo: _memo,
      sectionColor: _sectionColor,
    );

    final supabase = Supabase.instance.client;

    try {
      await supabase.from('schedule').insert(schedule.toJson()).then((value) =>
          context.read<ScheduleEventsProvider>().getScheduleEvents());
    } catch (error) {
      print('schedule insert 에러 $error');
    }

    // 새로고침을 위함도 있음.
    if (!mounted) return;
    context.read<CalendarProvider>().setSelectedDate(_startDate);
    Navigator.of(context).pop();
  }

  Future<void> _getDateFromUser(
      {required BuildContext context, required bool isStartTime}) async {
    DateTime? pickerDate = await showOmniDateTimePicker(
      context: context,
      theme: ThemeData(
        useMaterial3: true,
        // colorSchemeSeed: Color(0xff222E34),
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xff81CEE5),
            // 확인, 취소버튼 색
            onPrimary: Color(0xff222E34),
            // 선택한 날짜
            secondary: TRANSPARENT,
            onSecondary: Color(0xff3C6769),
            error: Colors.redAccent,
            onError: Colors.red,
            background: Color(0xff222E34),
            // 배경색
            onBackground: TRANSPARENT,
            // 확인, 취소버튼 구분선
            surface: Color(0xff222E34),
            onSurface: Colors.white),
        // 전체적인 글자색
        splashFactory: NoSplash.splashFactory,
        focusColor: TRANSPARENT,
        hoverColor: TRANSPARENT,
        highlightColor: TRANSPARENT,
      ),
      initialDate: isStartTime ? _originalStartTime : _originalEndTime,
      type: _isTimeSet
          ? OmniDateTimePickerType.dateAndTime
          : OmniDateTimePickerType.date,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
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
      print('pickerdate $pickerDate');

      setState(() {
        _originalStartTime = pickerDate ?? DateTime.now(); // 시작, 종료시각 비교를 위한 변수

        _startDate = pickerDate ?? DateTime.now();
        _startTime = DateFormat('hh:mm a').format(pickerDate!) ?? "06:00 AM";
      });
    } else if (isStartTime == false) {
      setState(() {
        _originalEndTime = pickerDate ?? DateTime.now();

        _endDate = pickerDate ?? DateTime.now();
        _endTime = DateFormat('hh:mm a').format(pickerDate!) ?? "08:00 AM";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _sectionColor = context
        .read<ScheduleColorProvider>()
        .colorIndex; // index를 선택하지 않았을 떄 default가 0이 되는 걸 막기 위함.

    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
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
                onPressed: _termsForSave() ? () => _onSavePressed() : null,
                child: Text(
                  '저장.',
                  style: TextStyle(color: _termsForSave() ? WHITE : GREY),
                  // TextStyle(color: value.text.isEmpty ? UNSELECTED : WHITE),
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
                  autofocus: false,
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
                        240,
                            '구분 색상',
                        Column(children: [ColorSelection()],),
                            TextButton(
                              child:
                                  Text('확인', style: TextStyle(color: COLOR1)),
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
                          _getDateFromUser(context: context, isStartTime: true);
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
                          activeColor: Color(0xff81CEE5),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        autofocus: false,
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
                                style: TextStyle(color: GREY),
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

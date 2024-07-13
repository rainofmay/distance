import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/functions/time_comarison.dart';
import 'package:mobile/view/schedule/widget/schedule/color_selection.dart';
import 'package:mobile/view/schedule/widget/schedule/omni_date_time_picker_theme.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../../model/schedule_model.dart';
import '../../../widgets/custom_text_field.dart';

class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));


  final ScheduleModel _editingScheduleModel = Get.arguments;
  final ScheduleProvider scheduleProvider = ScheduleProvider();

  final _formKey = GlobalKey<FormState>();
  late final String id = _editingScheduleModel.id;
  late String _scheduleName = _editingScheduleModel.scheduleName;
  late DateTime _startDate = _editingScheduleModel.startDate;
  late DateTime _endDate = _editingScheduleModel.endDate;

  late String? _startTime = _editingScheduleModel.startTime == "" ? "06:00 AM" : _editingScheduleModel.startTime;
  late String? _endTime = _editingScheduleModel.endTime == "" ? "08:00 AM" : _editingScheduleModel.endTime;
  late int _sectionColor = _editingScheduleModel.sectionColor;
  late bool _isTimeSet = _editingScheduleModel.isTimeSet;
  late String _memo = _editingScheduleModel.memo;
  late DateTime _originalStartTime = _editingScheduleModel.originalStartTime;
  late DateTime _originalEndTime = _editingScheduleModel.originalEndTime;

  String _selectedRepeat = "반복 없음";
  final List<String> repeatList = [
    "반복 없음",
    "매일",
    "매주",
    "매월",
  ];

  late final TextEditingController _titleController;
  late final TextEditingController _memoController;

  DateTime parseDateTime(String dateTimeString) {
    DateFormat format = DateFormat("yyyyMMdd hh:mm a");
    return Intl.withLocale('en', () => format.parse(dateTimeString));
  }

  @override
  void initState() {
    _titleController = TextEditingController(text: _editingScheduleModel.scheduleName);
    _memoController = TextEditingController(text: _editingScheduleModel.memo);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  _termsForSave() {
    if (timeComparison(_originalStartTime, _originalEndTime, _isTimeSet) ==
            false ||
        _endDate.day < _startDate.day ||
        _titleController.text.isEmpty) {
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
      id: id,
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
    );

    Get.back();

    await scheduleProvider.editScheduleData(schedule)
    .then((value) => viewModel.updateScheduleData(viewModel.selectedDate));

    // 이벤트 재랜더링과 연관 있는 기능들
    await viewModel.updateAllSchedules();
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
      lastDate:  DateTime.now().add(const Duration(days: 365 * 10 + 5)),
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
    return Obx(() => Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '',
        backFunction: () => Get.back(),
        backgroundColor: BLACK,
        contentColor: WHITE,
        isCenterTitle: false,
        actions: [
          ValueListenableBuilder(
            valueListenable: _titleController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return TextButton(
                onPressed: _termsForSave() ? _onSavePressed : null,
                child: Text(
                  '수정',
                  style: TextStyle(color: _termsForSave() ? WHITE : GREY),
                ),
              );
            },
          ),
          TextButton(
            onPressed: () async {
              await scheduleProvider.deleteScheduleData(id)
                  .then((value) => viewModel.updateScheduleData(viewModel.selectedDate));

              // 이벤트 재랜더링과 연관 있는 기능들
              await viewModel.updateAllSchedules();
              viewModel.updateSelectedDate(_startDate);
              Get.back();
            },
            child: const Text(
              '삭제',
              style: TextStyle(
                  color: Color(0xffc41b03), fontWeight: FontWeight.bold),
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
                const EdgeInsets.only(
                  left: 8.0,
                  top: 16.0,
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      readOnly: false,
                      controller: _titleController,
                      titleIcon: IconButton(
                          icon: Icon(CupertinoIcons.circle_filled,
                              color: sectionColors[viewModel.colorIndex]),
                          onPressed: () => {
                            // viewModel.updateColorIndex(_sectionColor),
                            customDialog(
                              context,
                              240,
                              '구분 색상',
                              Column(
                                children: [
                                  ColorSelection(scheduleViewModel: viewModel)
                                ],
                              ),
                              TextButton(
                                child:
                                Text('확인', style: TextStyle(color: WHITE)),
                                onPressed: () {
                                  _sectionColor = viewModel.colorIndex;
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          }),
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
                      controller: _memoController,
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
                                hint: _startTime == "" ? "06:00 AM" : _startTime, // value값 비었었다면 06:00 AM,
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
                                hint: _endTime == "" ? "08:00 AM" : _endTime,   // value값 비었었다면 08:00 AM,
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
                                CupertinoIcons.repeat,
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
                            dropdownColor: WHITE,
                            icon: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, right: 20.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ),
                            iconSize: 24,
                            isExpanded: true,
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
    ));
  }
}

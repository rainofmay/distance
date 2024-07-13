import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/schedule/widget/schedule/omni_date_time_picker_theme.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class RepeatScheduleWidget extends StatefulWidget {
  const RepeatScheduleWidget({super.key});

  @override
  State<RepeatScheduleWidget> createState() => _RepeatScheduleWidgetState();
}

class _RepeatScheduleWidgetState extends State<RepeatScheduleWidget> {
  String _selectedRepeatType = '반복 없음';
  final List<String> _repeatTypes = ['반복 없음', '지정'];
  final List<bool> _selectedDays = List.filled(7, false);
  int _selectedWeek = 1;
  DateTime _endDate = DateTime.now().add(Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: CustomTextField(
                autofocus: false,
                titleIcon: const IconButton(
                  icon: Icon(CupertinoIcons.repeat, color: Colors.black),
                  onPressed: null,
                ),
                readOnly: true,
                hint: _selectedRepeatType,
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButton<String>(
                style: const TextStyle(fontSize: 16),
                dropdownColor: WHITE,
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 16.0, right: 20.0),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ),
                iconSize: 24,
                isExpanded: true,
                underline: Container(height: 0),
                value: _selectedRepeatType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeatType = newValue!;
                  });
                },
                items: _repeatTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(value, style: const TextStyle(color: Colors.grey)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedRepeatType == '지정') ...[
                SizedBox(height: 16),
                Text('반복할 요일 선택', style: TextStyle(fontSize: 14, color: BLACK)),
                Wrap(
                  spacing: 5,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    return FilterChip(
                      backgroundColor: WHITE,
                      selectedColor: DARK,
                      checkmarkColor: PRIMARY_COLOR,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      label: Text(['월', '화', '수', '목', '금', '토', '일'][index], style: TextStyle(color: _selectedDays[index] == true ? PRIMARY_COLOR : DARK_UNSELECTED)),
                      selected: _selectedDays[index],
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedDays[index] = selected;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('반복 주기 ', style: TextStyle(color: BLACK, fontSize: 14)),
                    const SizedBox(width: 24),
                    DropdownButton<int>(
                      dropdownColor: WHITE,
                      value: _selectedWeek,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 18,
                      underline: Container(height: 0),
                      items: List.generate(52, (index) => index + 1).map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value주', style: TextStyle(color: BLACK, fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedWeek = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('종료일 : ${_endDate.toString().split(' ')[0]}'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: IconButton(onPressed: () async {
                        final DateTime? picked = await showOmniDateTimePicker(
                            context: context,
                            theme: OmniDateTimePickerTheme.theme,
                          initialDate: _endDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          barrierDismissible: true,
                          type: OmniDateTimePickerType.date
                        );
                        if (picked != null && picked != _endDate) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      }, icon: const Icon(CupertinoIcons.calendar, size: 20)),
                    )
                  ],
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}